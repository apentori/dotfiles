local luasnip = require("luasnip")

return {
  luasnip.snippet(
    "select",
    luasnip.text_node({
      "SELECT ",
      "\t", -- Tab to move cursor here
      "FROM ",
      "\t", -- Tab to move cursor here
      "WHERE ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "insert",
    luasnip.text_node({
      "INSERT INTO ",
      "\t", -- Tab to move cursor here
      "(",
      "\t", -- Tab to move cursor here
      ") VALUES (",
      "\t", -- Tab to move cursor here
      ");",
    })
  ),

  luasnip.snippet(
    "update",
    luasnip.text_node({
      "UPDATE ",
      "\t", -- Tab to move cursor here
      "SET ",
      "\t", -- Tab to move cursor here
      " = ",
      "\t", -- Tab to move cursor here
      "WHERE ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "delete",
    luasnip.text_node({
      "DELETE FROM ",
      "\t", -- Tab to move cursor here
      "WHERE ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "create",
    luasnip.text_node({
      "CREATE TABLE ",
      "\t", -- Tab to move cursor here
      "(",
      "\t", -- Tab to move cursor here
      ");",
    })
  ),

  luasnip.snippet(
    "join",
    luasnip.text_node({
      "SELECT ",
      "\t", -- Tab to move cursor here
      "FROM ",
      "\t", -- Tab to move cursor here
      "JOIN ",
      "\t", -- Tab to move cursor here
      "ON ",
      "\t", -- Tab to move cursor here
      " = ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "where",
    luasnip.text_node({
      "WHERE ",
      "\t", -- Tab to move cursor here
      " = ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "group",
    luasnip.text_node({
      "GROUP BY ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),

  luasnip.snippet(
    "order",
    luasnip.text_node({
      "ORDER BY ",
      "\t", -- Tab to move cursor here
      " ASC",
      ";",
    })
  ),

  luasnip.snippet(
    "limit",
    luasnip.text_node({
      "LIMIT ",
      "\t", -- Tab to move cursor here
      ";",
    })
  ),
}