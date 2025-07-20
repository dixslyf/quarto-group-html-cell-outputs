local container_classes = "cell-output-container"

function Meta(meta)
   local apply_default_styles = true

   if meta["wrap-cell-outputs"] then
      local config = meta["wrap-cell-outputs"]

      -- Parse configuration.
      if config["container-classes"] then
         assert(
            #config["container-classes"] == 1 and type(config["container-classes"][1].text) == "string",
            "Malformed value for `container-classes`"
         )
         container_classes = config["container-classes"][1].text
      end

      if config["apply-default-styles"] ~= nil then
         assert(type(config["apply-default-styles"]) == "boolean", "Malformed value for `apply-default-styles`")
         apply_default_styles = config["apply-default-styles"]
      end
   end

   if apply_default_styles then
      quarto.doc.add_html_dependency({
         name = "wrap-cell-outputs",
         version = "0.1.0",
         stylesheets = { "styles/wrap-cell-outputs.css" },
      })
   end

   return meta
end

function Div(el)
   if not el.classes:includes("cell") then
      return el
   end

   local cell_code = nil
   local output_children = {}
   for _, child in ipairs(el.content) do
      if child.t == "CodeBlock" and child.classes:includes("cell-code") then
         cell_code = child
      else
         -- Everything else is assumed to be part of the cell's output.
         table.insert(output_children, child)
      end
   end

   if #output_children <= 0 then
      return el
   end

   local new_content = {}

   if cell_code ~= nil then
      table.insert(new_content, cell_code)
   end

   if #output_children > 0 then
      local wrapper_div = pandoc.Div(output_children, { class = container_classes })
      table.insert(new_content, wrapper_div)
      assert((1 + #wrapper_div.content) == #el.content, "Unexpected length mismatch between old and new output content")
   else
      assert(#new_content == #el.content, "Unexpected length mismatch between old and new output content")
   end

   el.content = new_content
   return el
end

return {
   { Meta = Meta },
   { Div = Div },
}
