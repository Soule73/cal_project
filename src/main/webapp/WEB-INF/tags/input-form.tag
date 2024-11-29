<%@ tag import="java.util.Map" %>
<%@ tag pageEncoding="UTF-8"%>
<%@ attribute name="name" required="true" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="defaultText" required="false" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="label" required="false" %>
<%@ attribute name="isRequired" required="false" type="java.lang.Boolean" %>
<%
    String inputType = type != null ? type : "text";
    String inputPlaceholder = placeholder != null ? placeholder : "";
    boolean inputRequired = (isRequired != null) ? isRequired : false;%>
<div class="mb-4.5">
    <label
            class="mb-3 block text-sm font-medium text-black dark:text-white"
            for="<%= name %>">
        <%= label %>
        <% if (inputRequired) { %>
        <span class="text-meta-1">*</span>
        <% } %>
    </label>
    <input
            type="<%= inputType %>"
            id="<%= name %>"
            name="<%= name %>"
            value="<%= defaultText %>"
            placeholder="<%= inputPlaceholder %>"
            class="w-full rounded border-[1.5px] border-stroke bg-transparent px-5 py-3
                font-normal text-black outline-none transition focus:border-primary
                active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark
                dark:bg-form-input dark:text-white dark:focus:border-primary"/>

    <% if (request.getAttribute("errors") != null && ((Map<String, String>) request.getAttribute("errors")).containsKey(name)) { %>
    <span style="color: red;"><%= ((Map<String, String>) request.getAttribute("errors")).get(name) %></span>
    <% } %>
</div>
