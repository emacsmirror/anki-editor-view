from aqt import mw
from aqt.qt import *
import aqt
from aqt.utils import tooltip

from aqt import gui_hooks
from anki.hooks import addHook, wrap

def open_link(note_id):
    url = QUrl(f"org-protocol://anki-editor-view?id={note_id}")
    QDesktopServices.openUrl(url)
    tooltip("Opened note in Emacs")

def open_link_browser():
    browser = aqt.dialogs._dialogs["Browser"][1]
    note_id = None
    if browser != None:
        note_id = browser.card.nid
    if note_id:
        open_link(note_id)
    else:
        tooltip("No note is selected.")

def open_link_reviewer():
    if mw.state == "review" and mw.reviewer.card:
        open_link(mw.reviewer.card.nid)
    else:
        tooltip("No note is being reviewed.")

def addEmacsLinkActionToMenu(menu, f):
    menu.addSeparator()
    a = menu.addAction('Open Note in Emacs')
    a.setShortcut(QKeySequence("Ctrl+O"))
    a.triggered.connect(f)

def insert_reviewer_more_action(self, m):
    if mw.state != "review":
        return
    a = m.addAction('Browse Creation of This Card')
    a.setShortcut(QKeySequence("c"))
    a.triggered.connect(lambda _, s=mw.reviewer: browse_this_card(s))
    a = m.addAction('Browse Creation of Last Card')
    a.triggered.connect(lambda _, s=mw.reviewer: browse_last_card(s))

def setupMenuBrowser(self):
    menu = self.form.menu_Notes
    addEmacsLinkActionToMenu(menu, open_link_browser)

def setupMenuReviewer(self, menu):
    if mw.state != "review":
        return
    addEmacsLinkActionToMenu(menu, open_link_reviewer)

def fix_reviewer_shortcut(state, shortcuts):
    if state == "review":
        shortcuts.append(("Ctrl+O",open_link_reviewer))

addHook("browser.setupMenus", setupMenuBrowser)
addHook("Reviewer.contextMenuEvent", setupMenuReviewer)
gui_hooks.state_shortcuts_will_change.append(fix_reviewer_shortcut)
