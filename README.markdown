Setting up breadcrumbs
------------------------

Adding single breadcrumb:

    <% breadcrumbs ["My page", page_url] %>

End-point breadcrumb (won't generate a link):

    <% breadcrumb "Current page" %>

Adding multiple breadcrumbs:

    <% breadcrumbs << ["My page", page_url] << ["Other page", other_page_path] %>

Prepending breadcrumbs

    <% breadcrumbs >> ["This will be first", root_url]%>

Generating breadcrumbs with a block:

    <%
      breadcrumbs do |b|
        b << ["My page", page_url] if some_condition?
        b << "Current page"
      end
    %>

Breadcrumbs for objects (using helpers):

    <% breadcrumbs_for @page %> # Will call page_breadcrumbs(@page) helper to receive breadcrumb options

    <%
      breadcrumbs do |b|
        b.breadcrumbs_for(:root, @page) # will call root_page_breadcrumbs(@page)
      end
    %>


Generating HTML output
----------------------

Generate using default HTML markup^

    <%= breadcrumbs.to_html %>

Customize HTML markup (all blocks are optional):

    <% breadcrumbs.to_html do |b| %>
      <% b.separator do %> &raquo;&raquo;&raquo; <% end %>

      <% b.item do |item, index, items| %>
        <%= index %> of <%= items.size %>: <%= item.inspect %>
      <% end %>

      <% b.current do |item, index, items| %>
        <em>Last: <%= item.inspect %></em>
      <% end %>

      <% b.wrap do |result| %>
        <blockquote><%= result %></blockquote>
      <% end %>
    <% end %>
