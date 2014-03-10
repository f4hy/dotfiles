#! /usr/bin/python
import i3
import sys

current_node = i3.filter(focused=True)[0]
node = current_node
while node.get('type') != 4:
    node = i3.parent(node['id'])

all_windows = i3.filter(type=2, tree=node, nodes=[])

if not all_windows:
    sys.exit(0)

for num, window in enumerate(all_windows):
    if window['id'] == current_node['id']:
        break

if sys.argv[1] == 'next':
    try:
        new_focus = all_windows[num + 1]
    except IndexError:
        new_focus = all_windows[0]
elif sys.argv[1] == 'prev':
    try:
        new_focus = all_windows[num - 1]
    except IndexError:
        new_focus = all_windows[-1]
else:
    sys.exit(1)

i3.focus(con_id=new_focus['id'])
