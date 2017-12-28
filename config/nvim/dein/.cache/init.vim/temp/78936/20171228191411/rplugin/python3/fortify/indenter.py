# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

from lxml import etree as etree
from lxml.etree import CDATA
import jsbeautifier
import re

class Indenter:
  def indentxml(self, s, indent_structural=False):
    # replace brackets
    s = re.sub("<!\[CDATA\[(.*?)\]\]>", lambda x: "<![CDATA[" + x.group(1).replace('>','%GT%').replace('<','%LT%') + "]]>", s, flags=re.DOTALL)
    # convert to plain string without indents and spaces
    s = re.compile(r'>\s+([^\s])', re.DOTALL).sub('>\g<1>', s)
    # remove trailing spaces
    s = re.compile(r'(^\s*)', re.DOTALL).sub('%REMOVE%', s)
    s = s.replace('%REMOVE%', '')
    # replace empty tags to convince etree process to not auto close them
    s = re.compile(r'(<[^/]+>)(</\w*>)', re.DOTALL).sub('\g<1>%BREAK%\g<2>', s)
    # replace & signs
    s = s.replace('&', '%AMP%')
    # Prettyfy
    parser = etree.XMLParser(strip_cdata=False)  # remove_blank_text=True)
    tree = etree.fromstring(s, parser)
    self.indenttag(tree, level=0, indent_structural=indent_structural)
    s = etree.tostring(tree).decode("utf-8").strip()
    # remove line breaks
    s = re.compile(r'>\n\s+([^<>\s].*?)\n\s+</', re.DOTALL).sub('>\g<1></', s)
    # restore empty tags
    s = s.replace('%BREAK%', '')
    # restore "quotes" and brackets
    #s = s.replace('$quot;', '"')
    s = s.replace('%GT%', '>')
    s = s.replace('%LT%', '<')
    # replace & signs
    s = s.replace('%AMP%', '&')
    return s

  def indenttag(self, elem, level=0, indent_structural=False):
    i = "\n" + level * "    "
    if len(elem):
      if not elem.text or not elem.text.strip():
        elem.text = i + "    "
      for e in elem:
        self.indenttag(e, level=level+1, indent_structural=indent_structural)
        if not e.tail or not e.tail.strip():
          e.tail = i + "    "
      if not e.tail or not e.tail.strip():
        e.tail = i
    else:
      # Add CDATA delimiters (removed by ltree and indent content)
      # List of tags that require CDATA block
      if elem.text is not None and re.match(r'(StructuralMatch|Predicate|Definition|Script|Notes|Code|Explanation|Recommendations|Abstract)', elem.tag):
        text = elem.text
        if 'Definition' == elem.tag:
          text = self.indentdefinition(text, (level + 1) * "    ")
        elif indent_structural and re.match(r'(StructuralMatch|Predicate)', elem.tag):
          text = str(self.indentstructural(text, (level + 1) * "    "))
        elif 'Script' == elem.tag:
          text = self.indentjs(text, (level + 1) * "    ")
        else:
          text = self.indenttext(text, (level + 1) * "    ")
        if indent_structural:
          elem.text = CDATA("\n" + text + i)
        else:
          elem.text = CDATA("\n" + text)
        elem.tail = i
      if level and (not elem.tail or not elem.tail.strip()):
        elem.tail = i

  def indentstructural(self, s, prefix=""):
    # Line Comments
    s = re.sub(r'\s+\/\/(.*)\n', ' /* \g<1> */\n ', s)
    # convert to plain string without indents and spaces
    s = re.sub(r'\n,}', ' ', s, re.DOTALL)
    s = re.sub(r'\s{2,}', ' ', s)
    # remove leading spaces
    s = re.sub(r'(^\s*)', '', s, re.DOTALL)
    s = re.sub(r'(\])\s+(\])', '\g<1>\g<2>', s, re.DOTALL)
    # remove line breaks
    s = re.sub(r'\n\s+([^<>\s].*?)\n\s+', '\g<1>', s, re.DOTALL)
    # Clauses
    s = re.sub(r'\s+(and|or\s+)', '\n\g<1>', s, re.DOTALL)
    # Construct declarations
    s = re.sub(r'\s*(\w+\s*[A-Za-z0-9]*:\s+)([^\]])', '\g<1>\n\g<2>', s, re.DOTALL)
    s = re.sub(r'\[\s*(\w+\s*[A-Za-z0-9]*:\s+)([^\]])', '[\g<1>\n\g<2>', s, re.DOTALL)
    s = re.sub(r'\n(\s*)', '\n', s, re.DOTALL)
    # Closing Brackets
    s = re.sub(r'\]\]', ']\n]', s, re.DOTALL)
    s = re.sub(r'"\]', '"\n]', s, re.DOTALL)
    s = re.sub(r'([^\[][a-zA-Z0-9])\]', '\g<1>\n]', s, re.DOTALL)
    s = re.sub(r'([^:])\s+\]', '\g<1>\n]', s, re.DOTALL)
    # Block Comments
    s = re.sub(r'\/\*', '\n/*\n', s)
    s = re.sub(r'\*\/', '\n*/\n', s)

    # Indenting
    lines = s.split('\n')
    tabs = 0
    result = ""
    for i, line in enumerate(lines):
      empty_clause = re.search(r'\[\s*(\w+\s*[A-Za-z0-9]*:\s*)([^\]])', line)
      open_clause = re.search(r'\[\s*(\w+\s*[A-Za-z0-9]*:\s*)$', line)
      close_clause = re.search(r'^\s*\]\s*', line)
      if i == 1:
        tabs += 1
      if close_clause:
        tabs -= 1
      result +=  prefix + (tabs * "\t") + line + "\n"
      if open_clause:
        tabs += 1
    result = re.sub(r'(\[\s*\w+\s*[A-Za-z0-9]*:)\s*\n(\s*)(\])\s*', '\g<1> \g<3>\n\g<2>', result, re.DOTALL)

    # Merging one-line comments
    lines = result.split('\n')
    for i in range(0,len(lines)):
        if lines[i].strip() == "/*" and lines[i+2].strip() == "*/":
            lines[i] = lines[i] + " " + lines[i+1].strip() + " */"
            lines[i+1] = ""
            lines[i+2] = ""

    # Remove empty lines
    result = "\n".join([line for line in lines if line.strip() != ""])

    return result

  def indentjs(self, s, prefix=""):
    s = s.strip()
    s = s.replace('%AMP%', '&')
    opts = jsbeautifier.default_options()
    s = jsbeautifier.beautify(s, opts)
    lines = s.split('\n')
    result = ""
    for line in lines:
      line = prefix + line
      result = result + line + "\n"
    result = result.replace('&', '%AMP%')
    return result.strip("\n")

  def indentdefinition(self, s, prefix=""):
    indented = ""
    s = s.strip()
    lines = s.split('\n')
    result = []
    for i, line in enumerate(lines):
      if "}" == line.strip():
        indented = ""
      result.append(prefix + indented + line.strip())
      if "foreach" in line:
        indented = "\t"
    return "\n".join(result)

  def indenttext(self, s, prefix=""):
    lines = s.split('\n')
    if re.match(r'^\s*$', lines[0]):
      lines.pop(0)
    if re.match(r'^\s*$', lines[-1]):
      lines.pop()
    result = []
    lws = None
    aws = None
    rws = None
    for i, line in enumerate(lines):
      line = line.replace('\t', '    ')
      if i == 0:
        lws = len(line) - len(line.lstrip(' '))
        if lws > len(prefix):
          # need to shift left (remove ws)
          rws = lws - len(prefix)
        elif lws < len(prefix):
          # need to shift right (add ws)
          aws = len(prefix) - lws
        else:
          aws = 0
      if aws:
        result.append(' '*aws + line)
      elif rws:
        result.append(line.replace(' '*rws, '', 1))
    return "\n".join(result)

