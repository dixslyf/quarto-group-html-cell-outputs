local group_by_default = true
local default_container_classes = "cell-output-container"

function Meta(meta)
   local apply_default_styles = true

   if meta["group-html-cell-outputs"] then
      local config = meta["group-html-cell-outputs"]

      -- Parse configuration.
      if config["default-container-classes"] then
         assert(
            #config["default-container-classes"] == 1 and type(config["default-container-classes"][1].text) == "string",
            "Malformed value for `default-container-classes`"
         )
         default_container_classes = config["default-container-classes"][1].text
      end

      if config["group-by-default"] ~= nil then
         assert(type(config["group-by-default"]) == "boolean", "Malformed value for `group-by-default`")
         group_by_default = config["group-by-default"]
      end

      if config["apply-default-styles"] ~= nil then
         assert(type(config["apply-default-styles"]) == "boolean", "Malformed value for `apply-default-styles`")
         apply_default_styles = config["apply-default-styles"]
      end
   end

   if apply_default_styles then
      quarto.doc.add_html_dependency({
         name = "group-html-cell-outputs",
         version = "0.1.0",
         stylesheets = { "styles/default-cell-output-container.css" },
      })
   end

   return meta
end

function Div(el)
   if not el.classes:includes("cell") then
      return el
   end

   -- Check whether to group the outputs of the current cell.
   local should_group = group_by_default
   if el.attributes["group-outputs"] then
      should_group = el.attributes["group-outputs"] == "true"
   end

   if not should_group then
      return el
   end

   -- Determine what classes to apply.
   local container_classes = default_container_classes
   if el.attributes["output-container-classes"] then
      container_classes = el.attributes["output-container-classes"]
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
      local container_div = pandoc.Div(output_children, { class = container_classes })
      table.insert(new_content, container_div)
      assert(
         ((cell_code == nil and 0 or 1) + #container_div.content) == #el.content,
         "Unexpected length mismatch between old and new output content"
      )
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
