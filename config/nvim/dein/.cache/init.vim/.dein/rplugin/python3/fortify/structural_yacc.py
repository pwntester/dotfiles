# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import ply.yacc as yacc

try:
    from fortify.structural_lex import tokens
except:
    from structural_lex import tokens


class Node:
    def __init__(self, type, line=0, children=None, leaf=None, parent=None):
        self.type = type
        if children:
            self.children = children
        else:
            self.children = []
        self.leaf = leaf
        self.line = line
        self.parent = parent

"""
                 --------
                 | node |
                 --------
                     |
       -----------------------------
       |             |             |
   ---------     --------    ------------
   | type  |     | leaf |    | children |
   ---------     --------    ------------

    type: type, relation, subrule, reference, relation ...
    leaf: Function, FunctionCall, is, contains, ==, ...
"""

# <Rule> := <Label> <Expression>
def p_rule(t):
    '''rule : type expression
    | type'''
    line = t.lineno(1)
    if (len(t) == 3):
        t[0] = Node("rule", line, [t[1], t[2]])
    elif (len(t) == 2):
        t[0] = Node("rule", line, [t[1]])


# <Label> := <TypeName> [ <Identifier> ] ':'
def p_type(t):
    '''type : TYPENAME REFERENCE COLON
    | TYPENAME COLON'''
    line = t.lineno(1)
    if (len(t) == 4):
        var = Node("variable", line, None, t[2])
        t[0] = Node("type", line, [var], t[1])
    elif (len(t) == 3):
        t[0] = Node("type", line, None, t[1])


def p_expression(t):
    '''expression : literal
    | relation_expression
    | NOT expression
    | LPAREN expression RPAREN
    | expression LOGIC expression'''
    if (len(t) == 2):
        line = t.lineno(1)
        t[0] = t[1]
    elif (len(t) == 3):
        line = t.lineno(1)
        t[0] = Node("not", line, [t[2]])
    elif (len(t) == 4):
        if t[1] == "(":
            line = t.lineno(1)
            t[0] = Node("group", line, [t[2]], "Parentesis")
        else:
            line = t.lineno(2)
            t[0] = Node(t[2], line, [t[1], t[3]])


def p_expression_ref(t):
    '''expression : REFERENCE'''
    line = t.lineno(1)
    t[0] = Node("reference", line, None, t[1])


# <RelationExpression> := [ <Reference> | <Literal> ] <Relation> ( <Reference> | <Literal> | <SubRule> )
def p_relation(t):
    '''relation_expression : literal RELATION literal
    | literal RELATION subrule
    | RELATION literal
    | RELATION subrule'''
    if (len(t) == 3):
        line = t.lineno(1)
        t[0] = Node("relation", line, [t[2]], t[1])
    elif (len(t) == 4):
        line = t.lineno(2)
        t[0] = Node("relation", line, [t[1], t[3]], t[2])


def p_relation_ref(t):
    '''relation_expression : literal RELATION REFERENCE
    | RELATION REFERENCE'''
    if (len(t) == 4):
        line = t.lineno(2)
        node = Node('reference', line, None, t[3])
        t[0] = Node("relation", line, [t[1], node], t[2])
    elif (len(t) == 3):
        line = t.lineno(1)
        node = Node('reference', line, None, t[2])
        t[0] = Node("relation", line, [node], t[1])


def p_relation_ref_lit(t):
    '''relation_expression : REFERENCE RELATION literal
    | REFERENCE RELATION subrule'''
    line = t.lineno(2)
    node = Node('reference', line, None, t[1])
    t[0] = Node("relation", line, [node, t[3]], t[2])


def p_relation_ref_ref(t):
    '''relation_expression : REFERENCE RELATION REFERENCE'''
    line = t.lineno(2)
    node1 = Node('reference', line, None, t[1])
    node2 = Node('reference', line, None, t[3])
    t[0] = Node("relation", line, [node1, node2], t[2])


# <SubRule> := '[' [ <Label> ] <Expression> ']' [ '*' ]
def p_subrule(t):
    '''subrule : LBRACKET type expression RBRACKET
    | LBRACKET type expression RBRACKET STAR
    | LBRACKET type RBRACKET
    | LBRACKET type RBRACKET STAR
    | LBRACKET expression RBRACKET
    | LBRACKET expression RBRACKET STAR'''
    line = t.lineno(1)
    if (len(t) == 4):
        t[0] = Node("subrule", line, [t[2]])
    if (len(t) == 5):
        if t[4] == '*':
            t[0] = Node("subrule", line, [t[2]])
        else:
            t[0] = Node("subrule", line, [t[2], t[3]])
    elif (len(t) == 6):
        t[0] = Node("subrule", line, [t[2], t[3]])


# <Literal> := 'true' | 'false' | <StringLiteral> | <NumberLiteral>
def p_literal(t):
    '''literal : STRING1
    | STRING2
    | NUM
    | NULL
    | FALSE
    | TRUE'''
    line = t.lineno(1)
    t[0] = Node("literal", line, None, t[1])

# <Literal> := <TypeSignatureLiteral>
def p_typeliteral(t):
    '''literal : TYPE'''
    line = t.lineno(1)
    t[0] = Node("typeliteral", line, None, t[1])


# Error rule for syntax errors.
def p_error(t):
    if t is not None:
        raise SyntaxError("Invalid Syntax " + str(t.lexer.lineno))
    else:
        raise SyntaxError("Invalid Syntax UNKNOWN")

# Build the parser.
parser = yacc.yacc(optimize=False, debug=False, write_tables=False)
