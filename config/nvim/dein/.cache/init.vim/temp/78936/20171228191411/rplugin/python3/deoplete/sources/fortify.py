# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import os
import re
import sys

current_dir = os.path.dirname(os.path.abspath(__file__))
python_path = os.path.realpath(os.path.join(current_dir, '..', '..', 'fortify'))
sys.path.insert(0, python_path)
from completer import RuleCompleter

from .base import Base

class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)
        self.name = 'fortify'
        self.mark = '[sca]'
        self.rank = 500
        self.filetypes = ['fortifyrulepack']
        self.input_pattern = (r'[^. \t0-9]\.\w*|')

    def get_complete_position(self, context):
        m = re.search(r'\w*$', context['input'])
        return m.start() if m else -1

    def gather_candidates(self, context):
        text = "\n".join(self.vim.current.buffer)
        current_line = self.vim.current.line
        (row, col) = self.vim.current.window.cursor
        count = 0
        for i, l in enumerate(self.vim.current.buffer):
            if i < row - 1:
                count += len(l)+1
            else:
                count += col+1
                break
        cursor = [row,col+1,0,count]
        results = RuleCompleter().complete(text, current_line, cursor)

        res = []
        if current_line.strip() == "":
            return res

        for r in results:
            menu = r[0]
            word = r[1]
            abbr = r[1]
            if word.startswith('<') and '<' in current_line:
                word = r[1][1:]
            if word.endswith('>'):
                abbr = word[:-1]
            res.append({'word': word, 'abbr': abbr, 'menu': menu, 'dup':1})

        return res

