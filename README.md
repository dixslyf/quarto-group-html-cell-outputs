# `group-html-cell-outputs` Quarto Extension

The `group-html-cell-outputs` [Quarto](https://quarto.org/) extension adds a filter to group the outputs of a cell
by wrapping them with a parent `div` when rendering to HTML.

## Motivation

When Quarto renders a code cell to HTML,
it creates separate `div` elements for the code block, standard output (`stdout`) and error output (`stderr`).
These output `div`s are rendered as direct siblings of the code block `div`.
For certain input formats (notably, Jupyter notebooks),
there can be multiple, interleaved `stdout` and `stderr` `div`s.

The rendering behaviour described above presents two main issues:

1. Each output `div` has its own independent styling.
   Hence, for long outputs, there may be multiple, separate scrollbars for
   individual output blocks.
   This looks awkward and makes the cell output hard to read.

1. Since outputs are fragmented across different sibling `div`s,
   it is difficult to treat them as a single unit.
   For example, you cannot easily scroll or collapse all cell outputs together.
   Furthermore, when you have an extremely long list of such `div`s,
   it becomes difficult to limit their max height and show a scrollbar
   without accidentally hiding part of the code block.

This filter resolves these issues by wrapping the outputs of a cell
with a parent `div` element.
By default, the parent `div` is given the `cell-output-container` class.

## Installation

To install the `group-html-cell-outputs` extension for a project,
run the following in your shell:

```sh
quarto add dixslyf/quarto-group-html-cell-outputs
```

See Quarto's documentation on [Managing Extensions](https://quarto.org/docs/extensions/managing.html)
for more information.

## Usage

Please refer to the [documentation](https://dixslyf.github.io/quarto-group-html-cell-outputs/).
