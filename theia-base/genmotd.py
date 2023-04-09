import sys
import argparse
from termcolor import colored

parser = argparse.ArgumentParser('Gen anubis motd')
parser.add_argument('--write', dest='write', action='store_true', help='write to motd.txt file')
args = parser.parse_args()

if args.write:
    f = open('motd.txt', 'w')
else:
    f = sys.stdout

def text(txt, color='blue', attrs=['bold']):
    return colored(txt, color, attrs=attrs)

anubis_logo = text("""
    _                _     _
   / \\   _ __  _   _| |__ (_)___
  / _ \\ | '_ \\| | | | '_ \\| / __|
 / ___ \\| | | | |_| | |_) | \\__ \\
/_/   \\_|_| |_|\\__,_|_.__/|_|___/
"""[1:], 'green')

games = ['tetris', '2048', 'snake', 'moon-buggy']

messages = [
    text('Need a breather? Anubis has some terminal games now!\nAvailable games are: ') + text(', ').join(text(game, 'green') for game in games),
    text('Try using ') + text('l ', 'green') + text('instead of ') + text('ls ', 'red') + text('for prettier file listing.'),
    text(f'Try the autosave command to manually trigger an\nautosave: ') + text('% ', 'white') + text('anubis autosave', 'green'),
]

mark = text('-', 'red')

f.write(f'{anubis_logo}\n')
for item in messages:
    item = item.replace('\n', '\n  ')
    f.write(f'{mark} {item}\n')

