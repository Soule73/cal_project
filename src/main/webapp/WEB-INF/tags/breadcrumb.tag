<%@ tag %>
<%@ attribute name="name" %>

<!-- Breadcrumb Start -->
<div
        class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <h2 class="text-title-md2 font-bold text-black dark:text-white">
        ${name}
    </h2>

    <nav>
        <ol class="flex items-center gap-2">
            <li>
                <a class="font-medium" href="${pageContext.request.contextPath}/">Tableau de bord /</a>
            </li>
            <li class="font-medium text-primary">${name}</li>
        </ol>
    </nav>
</div>
<!-- Breadcrumb End -->