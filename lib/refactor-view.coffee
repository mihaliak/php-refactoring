{$, TextEditorView, View}  = require 'atom-space-pen-views'

module.exports =
class RefactorView extends View

    @activate: -> new RefactorView

    @content: ->
        @div class: 'php-refactor', =>
            @subview 'inputObject', new TextEditorView(mini: true, placeholderText: 'Enter name and press <Enter>')

    initialize: ->
        @extractMethodPanel = atom.workspace.addModalPanel({
            item: this,
            visible: false
        })

        @inputObject.on 'blur', => @hideModal()
        atom.commands.add @inputObject.element, 'core:cancel', => @hideModal()

    restoreFocus: ->
        if @lastFocusedElement?.isOnDom()
            @lastFocusedElement.focus()
        else
            atom.views.getView(atom.workspace).focus()

    showModal: ->
        return if @extractMethodPanel.isVisible()

        @lastFocusedElement = $(':focus')
        @inputObject.setText('')
        @extractMethodPanel.show()
        @inputObject.focus()

    hideModal: ->
        return unless @extractMethodPanel.isVisible()

        @extractMethodPanel.hide()
        @restoreFocus()
