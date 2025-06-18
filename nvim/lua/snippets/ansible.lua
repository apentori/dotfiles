return {
  luasnip.snippet(
    "task",
    luasnip.text_node({
      "- name: ",
      "\t", -- Tab to move cursor here
    })
  ),

  luasnip.snippet(
    "handler",
    luasnip.text_node({
      "- name: ",
      "  listen: \"\"",
      "  command: \"\"",
    })
  ),

  luasnip.snippet(
    "role/example",
    luasnip.text_node({
      "- name: ",
      "  hosts: ",
      "  tasks: ",
      "    - name: ",
      "      debug: ",
      "        msg: \"Hello, World!\"",
    })
  ),
}
