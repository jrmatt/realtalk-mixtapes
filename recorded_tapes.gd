extends VFlowContainer

var max_visible_children = 12


func _on_child_entered_tree(node: Node) -> void:
    print("New child entered: ", node.get_index())
    if get_child_count() > max_visible_children:
        for child in get_children():
            var i = child.get_index()
            if child.get_index() < get_child_count() - max_visible_children:
                child.visible = false 
