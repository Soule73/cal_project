<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ page import="com.cal.models.Language" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cal.Routes" %>
<!DOCTYPE html>
<html lang="fr">

<tg:head-style title="Liste des Langue"/>

<body
        x-data="{ page: 'listLanguages', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
        x-init="
          darkMode = JSON.parse(localStorage.getItem('darkMode'));
          $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
        :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}">
<!-- ===== Preloader Start ===== -->
<tg:preloader/>

<!-- ===== Preloader End ===== -->

<!-- ===== Page Wrapper Start ===== -->
<div class="flex h-screen overflow-hidden">
    <!-- ===== Sidebar Start ===== -->
    <tg:sidebar/>

    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div
            class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
        <!-- ===== Header Start ===== -->
        <tg:header/>

        <!-- ===== Header End ===== -->

        <!-- ===== Main Content Start ===== -->
        <main>
            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">

                <!-- Breadcrumb Start -->
                <tg:breadcrumb name="Liste des Langues"/>
                <!-- Breadcrumb End -->
                <%--                alert msg--%>
                <tg:alerts/>


                <!-- ====== Table Section Start -->
                <div class="flex flex-col gap-10">


                    <!-- ====== Table Three Start -->
                    <div
                            class="rounded-sm border border-stroke bg-white px-5 pb-2.5 pt-6 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
                        <div class="max-w-full overflow-x-auto">
                            <table class="w-full table-auto">
                                <thead>
                                <tr class="bg-gray-2 text-left dark:bg-meta-4">
                                    <th
                                            class="min-w-[220px] px-4 py-4 font-medium text-black dark:text-white xl:pl-11">
                                        ID
                                    </th>
                                    <th
                                            class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                        Nom
                                    </th>

                                    <th
                                            class="px-4 py-4 font-medium text-black dark:text-white">
                                        Actions
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    List<Language> languages = (List<Language>) request.getAttribute("languages");
                                    if (languages != null) {
                                        for (Language language : languages) {
                                %>
                                <tr>
                                    <td
                                            class="border-b border-[#eee] px-4 py-5 pl-9 dark:border-strokedark xl:pl-11">
                                        <h5 class="font-medium text-black dark:text-white">
                                            <%= language.getId() %>
                                        </h5>

                                    </td>
                                    <td
                                            class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                        <p class="text-black dark:text-white"><%= language.getName() %>
                                        </p>
                                    </td>

                                    <td
                                            class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                        <div class="flex items-center space-x-3.5">
                                            <a title="voir" href="${pageContext.request.contextPath}<%= Routes.LANG_SHOW %>?id=<%= language.getId() %>"
                                               class="hover:text-primary">
                                                <svg class="fill-current" width="18" height="18"
                                                     viewBox="0 0 18 18" fill="none"
                                                     xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                            d="M8.99981 14.8219C3.43106 14.8219 0.674805 9.50624 0.562305 9.28124C0.47793 9.11249 0.47793 8.88749 0.562305 8.71874C0.674805 8.49374 3.43106 3.20624 8.99981 3.20624C14.5686 3.20624 17.3248 8.49374 17.4373 8.71874C17.5217 8.88749 17.5217 9.11249 17.4373 9.28124C17.3248 9.50624 14.5686 14.8219 8.99981 14.8219ZM1.85605 8.99999C2.4748 10.0406 4.89356 13.5562 8.99981 13.5562C13.1061 13.5562 15.5248 10.0406 16.1436 8.99999C15.5248 7.95936 13.1061 4.44374 8.99981 4.44374C4.89356 4.44374 2.4748 7.95936 1.85605 8.99999Z"
                                                            fill=""/>
                                                    <path
                                                            d="M9 11.3906C7.67812 11.3906 6.60938 10.3219 6.60938 9C6.60938 7.67813 7.67812 6.60938 9 6.60938C10.3219 6.60938 11.3906 7.67813 11.3906 9C11.3906 10.3219 10.3219 11.3906 9 11.3906ZM9 7.875C8.38125 7.875 7.875 8.38125 7.875 9C7.875 9.61875 8.38125 10.125 9 10.125C9.61875 10.125 10.125 9.61875 10.125 9C10.125 8.38125 9.61875 7.875 9 7.875Z"
                                                            fill=""/>
                                                </svg>
                                            </a>


                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ====== Table Three End -->
                </div>
                <!-- ====== Table Section End -->
            </div>
        </main>
        <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->
<script defer src="${pageContext.request.contextPath}/bundle.js"></script>
</body>

</html>
