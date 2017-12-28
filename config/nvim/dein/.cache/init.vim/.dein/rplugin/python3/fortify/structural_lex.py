# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import ply.lex as lex

# List of token names.
tokens = ('TYPENAME', 'REFERENCE', 'NULL', 'FALSE', 'TRUE', 'LOGIC', 'NOT', 'COLON', 'STAR', 'LPAREN', 'RPAREN', 'LBRACKET', 'RBRACKET', 'TYPE', 'STRING1', 'STRING2', 'NUM', 'RELATION')


# Reserved words
reserved = {
    'false': 'FALSE',
    'true': 'TRUE',
    'or': 'LOGIC',
    'and': 'LOGIC',
    'not': 'NOT',
    '===': 'RELATION',
    '==': 'RELATION',
    '<': 'RELATION',
    '>': 'RELATION',
    '<=': 'RELATION',
    '>=': 'RELATION',
    '!=': 'RELATION',
    'is': 'RELATION',
    'contains': 'RELATION',
    'matches': 'RELATION',
    'in': 'RELATION',
    'endsWith': 'RELATION',
    'startsWith': 'RELATION',
    'reaches': 'RELATION',
    'reachedBy': 'RELATION',
    'null': 'NULL',
}

# Regular expression rules for simple tokens
t_COLON = r':'
t_STAR = r'\*'
t_LPAREN = r'\('
t_RPAREN = r'\)'
t_LBRACKET = r'\['
t_RBRACKET = r'\]'
t_FALSE = r'false'
t_TRUE = r'true'
t_NULL = r'NULL'
t_NOT = r'not'
t_LOGIC = r'and|or'
t_RELATION = r'===|==|<|>|<=|>=|!=|is|contains|matches|in|endsWith|startsWith|reaches|reachedBy'


def t_COMMENT(t):
    r'(/\*(.|\n)*?\*/)|(//.*)'
    pass
    # No return value. Token discarded


def t_NUM(t):
    r'\d+'
    try:
        t.value = int(t.value)
    except ValueError:
        print("Line %d: Number %s is too large!" % (t.lineno, t.value))
        t.value = 0
    return t


def t_TYPENAME(t):
    r'[A-Z]{1}[a-z][a-zA-Z]+'
    return t


def t_TYPE(t):
    r'T"[^"]*"'
    t.value = t.value[2:-1]
    return t


def t_REFERENCE(t):
    r'[a-zA-Z]([a-zA-Z0-9_]|\.|\[\d*\])*'
    t.type = reserved.get(t.value, 'REFERENCE')
    return t


def t_STRING1(t):
    r'\'[^"]*\''
    t.value[1:-1]
    return t


def t_STRING2(t):
    r'"[^"]*"'
    t.value[1:-1]
    return t



# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)


# A string containing ignored characters (spaces and tabs)
t_ignore = ' \t'


# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex(optimize=False, debug=False)
# structuralLexer.input('Variable p: p.annotations[0] is [Annotation a4:]')
# while 1:
#     tok = structuralLexer.token()
#     if not tok: break
#     print(tok)
