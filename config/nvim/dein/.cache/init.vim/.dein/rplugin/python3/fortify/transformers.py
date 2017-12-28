from lxml import etree as ltree
import uuid

def _get_rule_id():
  return str(uuid.uuid4()).upper()

"""
A Transformer is a plugin that  takes a rule (text) and return an array of new rules (text)
It can be used to modify a single rule (and so only returning the new version of the rule)
or to extend it (eg: generating number variants, sql/access control variants, sile from pv, etc.)

The transformer needs to define two class methods:
   - name
   - description
and a run() method that runs the transformation

It should not depend on vim or any other editors
"""

class Transformer(object):
  @classmethod
  def name(cls):
    return ""

  @classmethod
  def description(cls):
    return ""

  def run(self, rule):
    return list(rule)

class NumberVariants(Transformer):

  @classmethod
  def name(cls):
    return "NumberVariants"

  @classmethod
  def description(cls):
    return "Generates 3.12 NUMBER versions"

  def run(self, rule):
    try:
      parser = ltree.XMLParser(strip_cdata=False)
      rule1_string = ""
      root = ltree.fromstring(rule, parser)
      rule_type = root.tag
      # calculate rule indententation
      children = root.getchildren()
      indent = children[len(children) - 1].tail.strip('\n')

      # Generate 3.12, same ruleId, not Number rule
      if None == root.find("RuleID") or None ==  root.find("VulnKingdom") or None ==  root.find("VulnCategory") or None ==  root.find("DefaultSeverity") or None ==  root.find("Description"):
        #print('Rule has incomplete data. Missing RuleID, Kingdom, Category, Severity or Description')
        return None
      else:
        root.attrib['formatVersion'] = "3.12"
        # DataflowSinkRule
        if (rule_type == "DataflowSinkRule"):
          # find all sinks, if there are more than one, modify the primary one
          sink = None
          sinks = root.findall("Sink")
          if len(sinks) == 1:
            sink = sinks[0]
          elif len(sinks) > 1:
            for s in sinks:
              if s.get('primary') is not None:
                sink = s
          else:
            #print('No suitable sink')
            return None
          if sink is not None:
            cond = sink.find("Conditional")
            if cond is None:
              #print('No conditional block')
              return None
            sink.remove(cond)
            cond_tag = ltree.SubElement(sink, 'Conditional')
            and_tag = ltree.SubElement(cond_tag, 'And')
            not_tag = ltree.SubElement(and_tag, 'Not')
            number_tag = ltree.SubElement(not_tag, 'TaintFlagSet')
            number_tag.attrib['taintFlag'] = "NUMBER"
            for i, child in enumerate(cond.getchildren()):
              and_tag.insert(i+1,child)
        # CharacterizationRule TaintSink
        elif (rule_type == "CharacterizationRule"):
          definition = root.find("Definition")
          definition.text = ltree.CDATA(definition.text.replace(']', ' && !NUMBER]' ))

        rule1_string = indent + ltree.tostring(root).decode("utf-8")

      # Generate 3.12, different ruleId, Number rule, lower impact and probaility
      rule2_string = ""
      root = ltree.fromstring(rule, parser)
      if None == root.find("RuleID") or None ==  root.find("VulnKingdom") or None ==  root.find("VulnCategory") or None ==  root.find("DefaultSeverity") or None ==  root.find("Description"):
        #print('Rule has incomplete data. Missing RuleID, Kingdom, Category, Severity or Description')
        return None
      else:
        root.attrib['formatVersion'] = "3.12"
        root.find("RuleID").text = _get_rule_id()
        # Add metadata
        meta = root.find("MetaInfo")
        idx = len(meta.getchildren())
        group_impact_tag = ltree.SubElement(meta, 'Group')
        group_impact_tag.attrib['name'] = "Impact"
        group_impact_tag.text = "2"
        meta.insert(idx,group_impact_tag)
        group_prob_tag = ltree.SubElement(meta, 'Group')
        group_prob_tag.attrib['name'] = "Probability"
        group_prob_tag.text = "2"
        meta.insert(idx,group_prob_tag)
        # DataflowSinkRule
        if (rule_type == "DataflowSinkRule"):
          # find all sinks, if there are more than one, modify the primary one
          sink = None
          sinks = root.findall("Sink")
          if len(sinks) == 1:
            sink = sinks[0]
          elif len(sinks) > 1:
            for s in sinks:
              if s.get('primary') is not None:
                sink = s
          else:
            #print('No suitable sink')
            pass
          if sink is not None:
            cond = sink.find("Conditional")
            if cond is None:
              #print('No conditional block')
              return None
            sink.remove(cond)
            cond_tag = ltree.SubElement(sink, 'Conditional')
            and_tag = ltree.SubElement(cond_tag, 'And')
            number_tag = ltree.SubElement(and_tag, 'TaintFlagSet')
            number_tag.attrib['taintFlag'] = "NUMBER"
            for i, child in enumerate(cond.getchildren()):
              and_tag.insert(i+1,child)
        # CharacterizationRule TaintSink
        elif (rule_type == "CharacterizationRule"):
          definition = root.find("Definition")
          definition.text = ltree.CDATA(definition.text.replace(']', ' && NUMBER]' ))

        rule2_string = indent + ltree.tostring(root).decode("utf-8")
    except Exception as e:
      #print('The selection provided doesnt look like a set of rules %s' % e)
      pass

    if rule1_string is not "" and rule2_string is not "":
      return [rule, rule1_string, rule2_string]
    else:
      return None

class CharacterizationToStructural(Transformer):

  @classmethod
  def name(cls):
    return "CharacterizationToStructural"

  @classmethod
  def description(cls):
    return "Creates a new Structural rule with same predicate as the Characterization rule under cursor"

  def run(self, rule):
    try:
      parser = ltree.XMLParser(strip_cdata=False)
      structural_rule = ""
      root = ltree.fromstring(rule, parser)
      rule_type = root.tag
      children = root.getchildren()
      indent = children[len(children) - 1].tail.strip('\n')

      if rule_type != "CharacterizationRule":
        #print "Not a Characterization rule"
        return [rule]

      predicate_text = root.find("StructuralMatch")
      language = root.attrib['language']
      package = root.xpath('//MetaInfo/Group')
      if package and len(package) > 0:
        original_package = package[0].text
      else:
        original_package = "Test2"

      new_rule = ltree.Element('StructuralRule', formatVersion="3.2", language=language)
      metainfo = ltree.SubElement(new_rule, 'MetaInfo')
      package = ltree.SubElement(metainfo, 'Group', name='package')
      package.text = original_package
      ruleid = ltree.SubElement(new_rule, 'RuleID')
      ruleid.text = _get_rule_id()
      kingdom = ltree.SubElement(new_rule, 'VulnKingdom')
      kingdom.text = "Test"
      category = ltree.SubElement(new_rule, 'VulnCategory')
      category.text = "Test"
      severity = ltree.SubElement(new_rule, 'DefaultSeverity')
      severity.text = "5.0"
      description = ltree.SubElement(new_rule, 'Description')
      predicate = ltree.SubElement(new_rule, 'Predicate')
      predicate.text = ltree.CDATA(predicate_text.text)
      structural_rule = indent + ltree.tostring(new_rule).decode("utf-8")
    except Exception as e:
      #print('Error generating Structural Rule: %s' % e)
      pass

    if structural_rule is not "":
      return [rule, structural_rule]
    else:
      return [rule]

class HealthVariant(Transformer):

  @classmethod
  def name(cls):
    return "HealthVariant"

  @classmethod
  def description(cls):
      return "Generates \"Privacy Violation: Health\" variant"

  def run(self, rule):
    try:
      parser = ltree.XMLParser(strip_cdata=False)
      rule1_string = ""
      root = ltree.fromstring(rule, parser)
      rule_type = root.tag
      # calculate rule indententation
      children = root.getchildren()
      indent = children[len(children) - 1].tail.strip('\n')

      # Modify original rule, keep same ruleId, add NOT HEALTH 
      if None == root.find("RuleID") or None ==  root.find("VulnKingdom") or None ==  root.find("VulnCategory") or None ==  root.find("DefaultSeverity") or None ==  root.find("Description"):
        #print('Rule has incomplete data. Missing RuleID, Kingdom, Category, Severity or Description')
        return None
      else:
        # DataflowSinkRule
        if (rule_type == "DataflowSinkRule"):
          # find all sinks, if there are more than one, modify the primary one
          sink = None
          sinks = root.findall("Sink")
          if len(sinks) == 1:
            sink = sinks[0]
          elif len(sinks) > 1:
            for s in sinks:
              if s.get('primary') is not None:
                sink = s
          else:
            #print('No suitable sink')
            return None
          if sink is not None:
            cond = sink.find("Conditional")
            if cond is None:
              #print('No conditional block')
              return None
            sink.remove(cond)
            cond_tag = ltree.SubElement(sink, 'Conditional')
            and_tag = ltree.SubElement(cond_tag, 'And')
            not_tag = ltree.SubElement(and_tag, 'Not')
            number_tag = ltree.SubElement(not_tag, 'TaintFlagSet')
            number_tag.attrib['taintFlag'] = "HEALTH"
            for i, child in enumerate(cond.getchildren()):
              and_tag.insert(i+1,child)
        # CharacterizationRule TaintSink
        elif (rule_type == "CharacterizationRule"):
          definition = root.find("Definition")
          definition.text = ltree.CDATA(definition.text.replace(']', ' && !HEALTH]' ))

        rule1_string = indent + ltree.tostring(root).decode("utf-8")

      # Generate new HEALTH variant, different ruleId
      rule2_string = ""
      root = ltree.fromstring(rule, parser)
      if None == root.find("RuleID") or None ==  root.find("VulnKingdom") or None ==  root.find("VulnCategory") or None ==  root.find("DefaultSeverity") or None ==  root.find("Description"):
        #print('Rule has incomplete data. Missing RuleID, Kingdom, Category, Severity or Description')
        return None
      elif None != root.find("VulnSubcategory"):
        #print('Rule has unexpected subcategory')
        return None
      elif "Privacy Violation" != root.find("VulnCategory").text:
        #print('Rule has unexpected category')
        return None
      else:
        root.find("RuleID").text = _get_rule_id()
        # Add Health Information Subcategory
        cat = root.find("VulnCategory")
        root.insert(root.index(cat)+1, ltree.XML("<VulnSubcategory>Health Information</VulnSubcategory>"))
        # Modify Description reference
        desc = root.find("Description")
        desc.attrib['ref'] = desc.attrib['ref'] + "_health_information"


        # DataflowSinkRule
        if (rule_type == "DataflowSinkRule"):
          # find all sinks, if there are more than one, modify the primary one
          sink = None
          sinks = root.findall("Sink")
          if len(sinks) == 1:
            sink = sinks[0]
          elif len(sinks) > 1:
            for s in sinks:
              if s.get('primary') is not None:
                sink = s
          else:
            #print('No suitable sink')
            pass
          if sink is not None:
            cond = sink.find("Conditional")
            if cond is None:
              #print('No conditional block')
              return None
            sink.remove(cond)
            cond_tag = ltree.SubElement(sink, 'Conditional')
            and_tag = ltree.SubElement(cond_tag, 'And')
            number_tag = ltree.SubElement(and_tag, 'TaintFlagSet')
            number_tag.attrib['taintFlag'] = "HEALTH"
            for i, child in enumerate(cond.getchildren()):
              and_tag.insert(i+1,child)
        # CharacterizationRule TaintSink
        elif (rule_type == "CharacterizationRule"):
          definition = root.find("Definition")
          definition.text = ltree.CDATA(definition.text.replace(']', ' && HEALTH]' ))

        rule2_string = indent + ltree.tostring(root).decode("utf-8")
        rule2_string = rule2_string.replace('VALIDATED_PRIVACY_VIOLATION', 'VALIDATED_PRIVACY_VIOLATION_HEALTH_INFORMATION')
    except Exception as e:
      #print('The selection provided doesnt look like a set of rules %s' % e)
      pass

    if rule1_string is not "" and rule2_string is not "":
      return [rule1_string, rule2_string]
    else:
      return None
