# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import re
import os
import csv
import sys
import json
from io import BytesIO
from lxml import etree as ltree

try:
    import fortify.linter
except ImportError:
    try:
        import linter
    except ImportError:
        raise "Cannot import linter!"

def match(rex, str):
    m = rex.match(str)
    if m:
        return m.group(0)
    else:
        return None

def expandExtension(root, elements, attributes, type):
    complexType = root.find('.//{http://www.w3.org/2001/XMLSchema}complexType[@name="' + type + '"]')
    if complexType is not None:
        newelements = complexType.findall('.//{http://www.w3.org/2001/XMLSchema}element')
        # if newselements is not None:
        for element in newelements:
            elements.append(element)

        newattributes = complexType.findall('.//{http://www.w3.org/2001/XMLSchema}attribute')
        if newattributes is not None:
            attributes.extend(newattributes)

        newextension = complexType.find('.//{http://www.w3.org/2001/XMLSchema}extension')
        if newextension is not None:
            #print "Type " + type + " extends from " + newextension.get('base')
            elements = expandExtension(root, elements, attributes, newextension.get('base'))
    return elements


def resolveReferences(schema_root, elements, attributes):
    if elements is not None:
        for element in elements:
            if element is not None and element.tag == "{http://www.w3.org/2001/XMLSchema}element":
                if element.get('ref') is not None:
                    refelement = schema_root.find('.//{http://www.w3.org/2001/XMLSchema}element[@name="' + element.get('ref') + '"]')
                    if refelement is not None:
                        elements.append(refelement)
            elif element is not None and element.tag == "{http://www.w3.org/2001/XMLSchema}group":
                if element.get('ref') is not None:
                    refelement = schema_root.find('.//{http://www.w3.org/2001/XMLSchema}group[@name="' + element.get('ref') + '"]')
                    if refelement is not None:
                        groupelements = refelement.findall('.//{http://www.w3.org/2001/XMLSchema}element')
                        for e in groupelements:
                            elements.append(e)
    return (elements, attributes)


def resolveExtensions(schema_root, tag):
    tagelement = schema_root.find('./{http://www.w3.org/2001/XMLSchema}element[@name="' + tag + '"]')
    if tagelement is None:
        # Testing // instead of /
        tagelement = schema_root.find('.//{http://www.w3.org/2001/XMLSchema}element[@name="' + tag + '"]')
    if tagelement is not None:
        if tagelement.get('type') is not None:
            # Handle types like NamespaceName
            typeelement = schema_root.find('./{http://www.w3.org/2001/XMLSchema}complexType[@name="' + tagelement.get('type') + '"]')
            elements = typeelement.findall('.//{http://www.w3.org/2001/XMLSchema}element') if typeelement is not None else []
            attributes = typeelement.findall('.//{http://www.w3.org/2001/XMLSchema}attribute') if typeelement is not None else []
        elif tagelement.find('.//{http://www.w3.org/2001/XMLSchema}extension') is not None:
            extension = tagelement.find('.//{http://www.w3.org/2001/XMLSchema}extension')
            # Handle and Expand Extensions
            if extension is not None:
                # print("Tag " + tag + " extends from " + extension.get('base'))

                elements = []
                newelements = tagelement.findall('.//{http://www.w3.org/2001/XMLSchema}element')
                for element in newelements:
                    elements.append(element)

                attributes = tagelement.findall('./{http://www.w3.org/2001/XMLSchema}complexType/{http://www.w3.org/2001/XMLSchema}complexContent/{http://www.w3.org/2001/XMLSchema}extension/{http://www.w3.org/2001/XMLSchema}attribute')

                if elements is not None:
                    expandExtension(schema_root, elements, attributes, extension.get('base'))
        elif tagelement.find('.//{http://www.w3.org/2001/XMLSchema}group') is not None:
            elements = []
            group = tagelement.find('.//{http://www.w3.org/2001/XMLSchema}group')
            if group is not None:
                elements.append(group)
            attributes = tagelement.findall('./{http://www.w3.org/2001/XMLSchema}complexType//{http://www.w3.org/2001/XMLSchema}attribute')
        # No type, nor extended element, return the direct children elements
        else:
            elements = []
            sequence = tagelement.find('.//{http://www.w3.org/2001/XMLSchema}sequence')
            simpleType = tagelement.find('.//{http://www.w3.org/2001/XMLSchema}simpleType')
            if sequence is not None:
                elements = sequence.findall('.//{http://www.w3.org/2001/XMLSchema}element')
            elif simpleType is not None:
                elements = simpleType.findall('.//{http://www.w3.org/2001/XMLSchema}enumeration')
            else:
                elements = tagelement.findall('.//{http://www.w3.org/2001/XMLSchema}element')

            attributes = tagelement.findall('./{http://www.w3.org/2001/XMLSchema}complexType//{http://www.w3.org/2001/XMLSchema}attribute')
        # Before returning the elements and attributes, we need to resolve references
        (elements, attributes) = resolveReferences(schema_root, elements, attributes)

        return (elements, attributes)
    else:
        return ([], [])


def search_values(schema_root, tag, attribute):
    results = []
    # expand and resolve possible extensions, references and so on
    (elements, attributes) = resolveExtensions(schema_root, tag)
    for attr in attributes:
        if attribute == attr.get('name'):
            if attr.get('type') is not None:
                type = schema_root.find('.//{http://www.w3.org/2001/XMLSchema}simpleType[@name="' + attr.get('type') + '"]')
                if type is not None:
                    values = type.findall('.//{http://www.w3.org/2001/XMLSchema}enumeration')
                    for value in values:
                        results.append((value.get('value') + ' (Value)', value.get('value')))
            else:
                values = attr.findall('.//{http://www.w3.org/2001/XMLSchema}enumeration')
                for value in values:
                    results.append((value.get('value') + ' (Value)', value.get('value')))
    return results


def search_attributes(schema_root, tag):
    results = []

    # expand and resolve possible extensions, references and so on
    (elements, attributes) = resolveExtensions(schema_root, tag)

    if attributes is not None:
        for attribute in attributes:
            #print "Attribute: " + attribute.get('name')
            results.append((attribute.get('name') + ' (Attribute)', attribute.get('name') + "="))
    return results


def search_tags(schema_root, tag):
    results = []
    # expand and resolve possible extensions, references and so on
    (elements, attributes) = resolveExtensions(schema_root, tag)
    if elements is not None:
        for element in elements:
            if element.get('name', None) is not None:
                item = element.get('name')
                results.append((item + ' (Tag)', '<' + item + '>'))
            elif element.get('value') is not None:
                # For enumeration values
                item = element.get('value')
                results.append((item + ' (Value)', item))

    return results



def getLastTag(text):
    tagStack = []
    try:
        context = ltree.iterparse(BytesIO(text.encode('utf-8')), events=('end', 'start'), huge_tree=True)
        count = 0
        for event, elem in context:
            if event == 'start':
                # Called for each opening tag.
                index = elem.tag.index('}') + 1
                tag = elem.tag[index:]
                count += 1
                tagStack.append(tag)
            elif event == 'end':
                # Called for each closing tag.
                index = elem.tag.index('}') + 1
                tag = elem.tag[index:]
                for index, value in reversed(list(enumerate(tagStack))):
                    if value == tag:
                        tagStack.pop(index)
                elem.clear()
                while elem.getprevious() is not None:
                    del elem.getparent()[0]
        context = None
    except:
        pass
    if len(tagStack) > 0:
        return tagStack.pop()
    else:
        return ''


def completeVulnCatInfo(text):
    language = ''
    vulnKingdom = ''
    vulnCategory = ''
    lastTag = ''
    context = ltree.iterparse(BytesIO(text.encode('utf-8')), events=('end', 'start'))
    try:
        for event, elem in context:
            if event == 'start':
                # Called for each opening tag.
                index = elem.tag.index('}') + 1
                tag = elem.tag[index:]
                lastTag = tag
                if re.match(r'(?i).*Rule$', elem.tag):
                    language = elem.attrib['language'] if 'language' in elem.attrib else ''
                    vulnKingdom = ''
                    vulnCategory = ''
            elif event == 'end':
                # Called when data is read from a tag
                if re.match(r'(?i)VulnKingdom', lastTag) and elem.text.strip():
                    vulnKingdom = elem.text
                    vulnCategory = ''
                elif re.match(r'(?i)VulnCategory', lastTag) and elem.text.strip():
                    vulnCategory = elem.text
                elem.clear()
                while elem.getprevious() is not None:
                    del elem.getparent()[0]
    except:
        pass
    context = None
    results = []
    vulncat_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "resources", "lang-king-cat-subcat.csv")
    if language is not None and vulnKingdom == '' and vulnCategory == '':
        # Parsing VulnCat dtree to get Kingdoms for a given Language
        with open(vulncat_path, 'r') as csvfile:
            vulncat = csv.reader(csvfile, delimiter=',')
            for row in vulncat:
                if (row[0] == language):
                    if not (row[1] + ' (Value)', row[1]) in results:
                        results.append((row[1] + ' (Value)', row[1]))

    elif language is not None and vulnKingdom != '' and vulnCategory == '':
        # Parsing VulnCat dtree to get Kingdoms for a given Language
        with open(vulncat_path, 'r') as csvfile:
            vulncat = csv.reader(csvfile, delimiter=',')
            for row in vulncat:
                if (row[0] == language and row[1] == vulnKingdom):
                    if not (row[2] + ' (Value)', row[2]) in results:
                        results.append((row[2] + ' (Value)', row[2]))

    elif language is not None and vulnKingdom != '' and vulnCategory != '':
        # Parsing VulnCat dtree to get Kingdoms for a given Language
        with open(vulncat_path, 'r') as csvfile:
            vulncat = csv.reader(csvfile, delimiter=',')
            for row in vulncat:
                if (row[0] == language and row[1] == vulnKingdom and row[2] == vulnCategory):
                    if not (row[3] + ' (Value)', row[3]) in results:
                        results.append((row[3] + ' (Value)', row[3]))

    return results


class RuleCompleter():

    def __init__(self):
        self.schema = None

        self.autocomplete_values = {
            "DefaultSeverity_tag" : ["1.0", "2.0", "3.0", "4.0", "5.0"],
            "Group[Impact]_tag" : ["0.0", "2", "2.0", "2.5", "3", "3.0", "4.0", "5.0"],
            "Group[Accuracy]_tag" : ["0.0", "1.0", "2.0", "3.0", "4", "4.0", "5.0"],
            "Group[RemediationEffort]_tag" : ["0.0", "1.0", "2.0", "3.0"],
            "Group[Probability]_tag" : ["1", "1.0", "2", "2.0", "3.0", "3.5", "4.0", "5.0"],
            "Group[PrimaryAudience]_tag" : ["quality", "security"],
            "Group[ImpactBias]_tag" : ["Availability", "Confidentiality", "Integrity", "None"],
            "Group[ConfidentialityImpact]_tag" : ["Complete", "None", "Partial"],
            "Group[IntegrityImpact]_tag" : ["Complete", "None", "Partial"],
            "Group[AvailabilityImpact]_tag" : ["Complete", "None"],
            "Group[audience]_tag" : ["broad", "fod,medium,broad", "dev,medium,broad", "fod,broad", "fod,dev,targeted,medium,broad", "fod,targeted,medium,broad", "medium,broad"],
            "Description_attr": ["ref=\"$\"", "id=\"$\"", "formatVersion=\"$\""],
            "OutArguments_tag" : ["return", "this", "0..."],
            "InArguments_tag" : ["return", "this", "0..."],
            "Group_attr" : ["name=\"$\""],
            "Pattern_attr": ["caseInsensitive=\"$\""],
            "Value_attr": ["caseInsensitive=\"$\""],
            "Group_name_value" : ["Accuracy", "Impact", "RemediationEffort", "Probability", "package", "inputsource", "product"]
        }

        if self.schema is None:
            self.load_schema()

    def search_settings(self, tag):
        """
        Fetch autocomplete values from the settings dict. To be used if the information cannot be retrieved from the XSD schema
        """
        results = []
        values = self.autocomplete_values.get(tag, None)
        if values is not None:
            for value in values:
                results.append((value + ' (Value)', value))
        return results

    def load_schema(self):
        schema_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "resources", "rules.xsd")
        schema_file = open(schema_path, 'rb')
        schema_contents = schema_file.read()
        self.schema = ltree.XML(schema_contents)
        schema_file.close()

    def complete(self, text, current_line, cursor):
        unterminatedtag = ''
        attribute = ''
        groupAttr = ''

        text_to_cursor = "\n".join(text.split("\n")[:cursor[0]-1]) + "\n" + current_line[:cursor[1]-1]
        line_to_cursor = current_line[:cursor[1]-1]

        # from this point cursor and text is only used in the structural block completion
        # current_line is no longer used

        # Recover the last unclosed tag
        tag = getLastTag(text_to_cursor)
        if tag == '':
            return []

        # Checking last characters
        ch1 = line_to_cursor[-2:-1]
        ch2 = line_to_cursor[-1:]
        if ch1 == '=' and ch2 == '"':
            attribute = line_to_cursor[line_to_cursor.rfind(" ")+1:-2]

        # Cheking unterminated tags
        obindex = text_to_cursor.rfind("<")
        cdindex = text_to_cursor.rfind("<![")
        if obindex == cdindex:
            obindex = text_to_cursor[:obindex-1].rfind("<")
        cbindex = text_to_cursor.rfind(">")
        if (obindex > cbindex):
            # Looks like we are inside a tag definition
            unterminatedtag = text_to_cursor[obindex + 1:text_to_cursor.find(" ",obindex+1)]

        if (tag == "Group" and cbindex > obindex):
            groupIndex = text_to_cursor.rfind("Group")
            nameIndex = text_to_cursor.rfind("name=")
            if (nameIndex > groupIndex):
                quoteIndex = text_to_cursor.find('"', nameIndex + 6)
                groupAttr = text_to_cursor[nameIndex + 6:quoteIndex]

        # Deal with open quotes: attribute="CURSORHERE"
        if len(tag) > 0 and len(unterminatedtag) > 0 and len(attribute) > 0:
            # Look for the tag in the settings file
            settingsResults = self.search_settings(unterminatedtag + "_" + attribute + "_value")
            if settingsResults != []:
                return (settingsResults)
            else:
                return (search_values(self.schema, unterminatedtag, attribute))

        # Deal with unterminated tags: <tag attr="x" CURSORHERE
        elif len(tag) > 0 and len(attribute) == 0 and len(unterminatedtag) > 0:
            # Look for the tag in the settings file
            settingsResults = self.search_settings(unterminatedtag + "_attr")
            if settingsResults != []:
                return (settingsResults)
            else:
                return (search_attributes(self.schema, unterminatedtag))

        # Deal with unclosed tags: <tag> CURSORHERE
        elif len(tag) > 0:
            # Look for the tag in the settings file
            if (len(groupAttr) > 0):
                settingsResults = self.search_settings(tag + "[" + groupAttr + "]_tag")
            else:
                settingsResults = self.search_settings(tag + "_tag")

            if len(settingsResults) > 0:
                return (settingsResults)
            elif re.match(r'(?i)(VulnKingdom|VulnCategory|VulnSubCategory)', tag):
                # The autocomplete info is not in the schema so check the vulnCat instead
                return (completeVulnCatInfo(text))
            elif re.match(r'(?i)(Predicate|StructuralMatch)', tag):
                # Structural block
                block_start = cdindex
                block_end = text.find("]]>", cdindex)
                code = text[block_start:block_end]
                code = code.replace("<![CDATA[", "")
                block_start = block_start+len("<![CDATA[")+1
                block_end = block_end
                point = cursor[3] - 1
                code1 = text[block_start:point]
                code2 = text[point:block_end]
                if code1.endswith("["):
                    code = code1 + "Complete:" + code2
                else:
                    code = code1 + "COMPLETE" + code2
                import linter
                suggestions = linter.get_complete_suggestions(code)
                if suggestions is not None:
                    results = []
                    for (vname, vtype, vdesc) in suggestions:
                        results.append((vname + ' ' + vdesc, vname))
                    return (results)
                else:
                    return []
            else:
                return (search_tags(self.schema, tag))
        else:
            return []

