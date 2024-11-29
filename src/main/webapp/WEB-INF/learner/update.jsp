<%@ page import="com.cal.Routes" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ page import="com.cal.models.Learner" %>
<%
    com.cal.models.Learner apprenant = (Learner) request.getAttribute("apprenant");
%>
<!DOCTYPE html>
<html lang="fr">

<tg:head-style title="Modifir l'apprenant"/>


<body
        x-data="{ page: 'addApprenant', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
        x-init="
          darkMode = JSON.parse(localStorage.getItem('darkMode'));
          $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
        :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}"
>
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
            class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden"
    >
        <!-- ===== Header Start ===== -->
        <tg:header/>

        <!-- ===== Header End ===== -->

        <!-- ===== Main Content Start ===== -->
        <main>
            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
                <!-- Breadcrumb Start -->
                <tg:breadcrumb name="Modifir l'apprenant"/>
                <!-- Breadcrumb End -->
                <%-- alert msg--%>
                <tg:alerts/>
                <!-- ====== Form Layout Section Start -->
                <div class="flex flex-col gap-9 max-w-2xl mx-auto">
                    <!-- Contact Form -->
                    <div
                            class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"
                    >
                        <div
                                class="border-b border-stroke px-6.5 py-4 dark:border-strokedark"
                        >
                            <h3 class="font-medium text-black dark:text-white">Modifir l'apprenant
                            </h3>
                        </div>
                        <form action="${pageContext.request.contextPath}<%=Routes.LEARNER_UPDATE%>" method="post" >
                            <input type="hidden" name="id" value="<%= apprenant.getId() %>">

                            <div class="p-6.5">

                                <tg:input-form
                                        label="Prénom"
                                        name="firstname"
                                        placeholder="Entrer le prénom"
                                        isRequired="true"
                                        defaultText='<%= request.getParameter("firstname") != null ? request.getParameter("firstname") : apprenant.getFirstname() %>'
                                />

                                <tg:input-form
                                        label="Nom de famille"
                                        name="lastname"
                                        placeholder="Entrer le nom de famille"
                                        isRequired="true"
                                        defaultText='<%= request.getParameter("lastname") != null ? request.getParameter("lastname") : apprenant.getLastname() %>'
                                />

                                <tg:input-form
                                        label="E-mail"
                                        name="email"
                                        type="email"
                                        placeholder="Entrer l'adresse email"
                                        isRequired="true"
                                        defaultText='<%= request.getParameter("email") != null ? request.getParameter("email") : apprenant.getEmail() %>'
                                />

                                <button
                                        type="submit"
                                        class="flex w-full justify-center rounded bg-primary p-3 font-medium text-gray hover:bg-opacity-90"
                                >
                                   Enrégistre
                                </button>
                            </div>
                        </form>
                    </div>
                </div>


                <!-- ====== Form Layout Section End -->
            </div>
        </main>
        <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->

<script defer src="${pageContext.request.contextPath}/bundle.js"></script></body>
</html>