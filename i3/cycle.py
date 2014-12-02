#! /usr/bin/python
import i3
import sys


def focus_next():
    name = i3.filter(i3.get_workspaces(), focused=True)[0]['name']
    ws_nodes = i3.filter(name=name)[0]['nodes']
    curr = i3.filter(ws_nodes, focused=True)[0]

    ids = [win['id'] for win in i3.filter(ws_nodes, nodes=[])]

    next_idx = (ids.index(curr['id']) + 1) % len(ids)
    next_id = ids[next_idx]

    i3.focus(con_id=next_id)

focus_next()
