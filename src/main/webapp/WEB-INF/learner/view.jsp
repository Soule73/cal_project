<%@ page import="com.cal.models.User" %>

<%@ page import="com.cal.Routes" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tgl" tagdir="/WEB-INF/tags/learners" %>


<%
    User apprenant = (User) request.getAttribute("apprenant");

%>

<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="fr">
<tg:head-style title="Détails de l'Apprenant"/>
<body

        x-data="{ page: 'viewApprenant', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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
                <tg:breadcrumb name="Détails de l'Apprenant"/>
                <!-- Breadcrumb End -->
                <tgl:unsub-form/>
                <!-- ====== Profile Section Start -->
                <div
                        class="overflow-hidden rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"
                >
                    <div class="relative z-20 h-35 md:h-65">
                        <img
                                src="${pageContext.request.contextPath}/src/images/cover/cover.svg"
                                alt="profile cover"
                                class="h-full w-full rounded-tl-sm rounded-tr-sm object-cover object-center"
                        />

                    </div>
                    <div class="px-4 pb-6 text-center lg:pb-8 xl:pb-11.5">
                        <div
                                class="relative z-30 mx-auto -mt-22 h-30 w-full max-w-30 rounded-full bg-white/20 p-1 backdrop-blur sm:h-44 sm:max-w-44 sm:p-3"
                        >
                            <div class="relative drop-shadow-2">
                                <img src="${pageContext.request.contextPath}/src/images/user/profile.svg"
                                     alt="profile"/>
                                <label
                                        for="profile"
                                        class="absolute bottom-0 right-0 flex h-8.5 w-8.5 cursor-pointer items-center justify-center rounded-full bg-primary text-white hover:bg-opacity-90 sm:bottom-2 sm:right-2"
                                >
                                    <svg
                                            class="fill-current"
                                            width="14"
                                            height="14"
                                            viewBox="0 0 14 14"
                                            fill="none"
                                            xmlns="http://www.w3.org/2000/svg"
                                    >
                                        <path
                                                fill-rule="evenodd"
                                                clip-rule="evenodd"
                                                d="M4.76464 1.42638C4.87283 1.2641 5.05496 1.16663 5.25 1.16663H8.75C8.94504 1.16663 9.12717 1.2641 9.23536 1.42638L10.2289 2.91663H12.25C12.7141 2.91663 13.1592 3.101 13.4874 3.42919C13.8156 3.75738 14 4.2025 14 4.66663V11.0833C14 11.5474 13.8156 11.9925 13.4874 12.3207C13.1592 12.6489 12.7141 12.8333 12.25 12.8333H1.75C1.28587 12.8333 0.840752 12.6489 0.512563 12.3207C0.184375 11.9925 0 11.5474 0 11.0833V4.66663C0 4.2025 0.184374 3.75738 0.512563 3.42919C0.840752 3.101 1.28587 2.91663 1.75 2.91663H3.77114L4.76464 1.42638ZM5.56219 2.33329L4.5687 3.82353C4.46051 3.98582 4.27837 4.08329 4.08333 4.08329H1.75C1.59529 4.08329 1.44692 4.14475 1.33752 4.25415C1.22812 4.36354 1.16667 4.51192 1.16667 4.66663V11.0833C1.16667 11.238 1.22812 11.3864 1.33752 11.4958C1.44692 11.6052 1.59529 11.6666 1.75 11.6666H12.25C12.4047 11.6666 12.5531 11.6052 12.6625 11.4958C12.7719 11.3864 12.8333 11.238 12.8333 11.0833V4.66663C12.8333 4.51192 12.7719 4.36354 12.6625 4.25415C12.5531 4.14475 12.4047 4.08329 12.25 4.08329H9.91667C9.72163 4.08329 9.53949 3.98582 9.4313 3.82353L8.43781 2.33329H5.56219Z"
                                                fill=""
                                        />
                                        <path
                                                fill-rule="evenodd"
                                                clip-rule="evenodd"
                                                d="M7.00004 5.83329C6.03354 5.83329 5.25004 6.61679 5.25004 7.58329C5.25004 8.54979 6.03354 9.33329 7.00004 9.33329C7.96654 9.33329 8.75004 8.54979 8.75004 7.58329C8.75004 6.61679 7.96654 5.83329 7.00004 5.83329ZM4.08337 7.58329C4.08337 5.97246 5.38921 4.66663 7.00004 4.66663C8.61087 4.66663 9.91671 5.97246 9.91671 7.58329C9.91671 9.19412 8.61087 10.5 7.00004 10.5C5.38921 10.5 4.08337 9.19412 4.08337 7.58329Z"
                                                fill=""
                                        />
                                    </svg>
                                    <input
                                            type="file"
                                            name="profile"
                                            id="profile"
                                            class="sr-only"
                                    />
                                </label>
                            </div>
                        </div>

                        <div class="mt-4">
                            <h3
                                    class="mb-1.5 text-2xl font-medium text-black dark:text-white"
                            >
                                <%= apprenant.getFullname() %>
                            </h3>
                            <p class="font-medium">
                                <strong>ID : </strong> #<%= String.format("%05d", apprenant.getId()) %> |
                                <strong>E-mail : </strong> <%= apprenant.getEmail() %>
                            </p>

                        </div>


                    </div>
                </div>
                <!-- ====== Profile Section End -->
                <!-- ====== languages Table Start -->
                <div
                        class="rounded-sm border border-y-transparent border-stroke bg-white px-5 pb-2.5 pt-6 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">

                    <div class="max-w-full py-6 overflow-x-auto">
                        <table class="w-full table-auto">
                            <thead>
                            <tr class="bg-gray-2 text-left dark:bg-meta-4">
                                <th
                                        class="min-w-[220px] px-4 py-4 font-medium text-black dark:text-white xl:pl-11">
                                    Langue
                                </th>
                                <th
                                        class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                    Niveau
                                </th>
                                <th
                                        class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                    Description
                                </th>

                            </tr>
                            </thead>
                            <tbody>

                            <tr>

                                <td
                                        class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                    <p class="text-black dark:text-white">
                                        <%= apprenant.getLanguage().getName() %>
                                    </p>
                                </td>
                                <td
                                        class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                    <p
                                            class="inline-flex px-3 py-1 text-sm font-medium text-success">
                                        <%= apprenant.getLevel().getName() %>
                                    </p>
                                </td>
                                <td
                                        class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                    <p class="text-black dark:text-white">
                                        <%= apprenant.getLevel().getDescription()%>
                                    </p>
                                </td>

                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- ====== languages Table End -->

                <!-- ====== Subscrition Start -->
                <div x-data="learnerSubscriptions()" x-init="init" x-cloak>
                    <div class="rounded-sm border border-stroke bg-white px-5 pb-2.5 pt-6 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
                        <div class=" flex justify-between ">
                            <h4 class="mb-6 text-xl font-bold text-black dark:text-white">Abonnements</h4>
                            <tgl:add-subscription-form/>
                        </div>
                        <div class="max-w-full py-6 overflow-x-auto">
                            <template x-for="subscription in subscriptions" :key="subscription.id">
                                <div x-data="{ accordionOpen: false }" @click.outside="accordionOpen = false"
                                     class="rounded-md border border-stroke p-4 dark:border-strokedark sm:p-6">
                                    <button @click="accordionOpen = !accordionOpen"
                                            class="flex w-full items-center gap-1.5 sm:gap-3 xl:gap-6">
                                        <div class="flex h-10.5 w-full max-w-10.5 items-center justify-center rounded-md bg-[#F3F5FC] dark:bg-meta-4">
                                            <svg :class="accordionOpen && 'rotate-180'"
                                                 class="fill-primary stroke-primary duration-200 ease-in-out dark:fill-white dark:stroke-white"
                                                 width="18" height="10" viewBox="0 0 18 10" fill="none"
                                                 xmlns="http://www.w3.org/2000/svg">
                                                <path d="M8.28882 8.43257L8.28874 8.43265L8.29692 8.43985C8.62771 8.73124 9.02659 8.86001 9.41667 8.86001C9.83287 8.86001 10.2257 8.69083 10.5364 8.41713L10.5365 8.41721L10.5438 8.41052L16.765 2.70784L16.771 2.70231L16.7769 2.69659C17.1001 2.38028 17.2005 1.80579 16.8001 1.41393C16.4822 1.1028 15.9186 1.00854 15.5268 1.38489L9.41667 7.00806L3.3019 1.38063L3.29346 1.37286L3.28467 1.36548C2.93287 1.07036 2.38665 1.06804 2.03324 1.41393L2.0195 1.42738L2.00683 1.44184C1.69882 1.79355 1.69773 2.34549 2.05646 2.69659L2.06195 2.70196L2.0676 2.70717L8.28882 8.43257Z"
                                                      fill="" stroke=""></path>
                                            </svg>
                                        </div>

                                        <h4 class="text-left text-title-xsm font-medium text-black dark:text-white"
                                            x-text="subscription.name"></h4>
                                        <div @click="unSubcr(subscription)" class=" text-red-600">
                                            Désabonner
                                        </div>
                                    </button>
                                    <div x-show="accordionOpen" class="mt-5 duration-200 ease-in-out">
                                        <p class="ml-16.5 py-4 font-medium" x-text="subscription.description"></p>
                                        <div class="rounded-sm border-t border-stroke bg-white px-5 pb-2.5 pt-6 dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
                                            <h4 class="mb-1 text-xl font-bold text-black dark:text-white">Cours</h4>
                                            <div class="max-w-full pb-6 overflow-x-auto">
                                                <table class="w-full table-auto">
                                                    <thead>
                                                    <tr class="bg-gray-2 text-left dark:bg-meta-4">
                                                        <th class="min-w-[220px] px-4 py-4 font-medium text-black dark:text-white xl:pl-11">
                                                            Identifiant
                                                        </th>
                                                        <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                            Nom
                                                        </th>
                                                        <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                            Description
                                                        </th>
                                                        <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                            Type de Cours
                                                        </th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <template x-for="course in subscription.courses" :key="course.id">
                                                        <tr>
                                                            <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                                <p class="text-black dark:text-white"
                                                                   x-text="course.identifier"></p></td>
                                                            <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                                <p class="inline-flex px-3 py-1 text-sm font-medium text-success"
                                                                   x-text="course.name"></p></td>
                                                            <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                                <p class="text-black dark:text-white"
                                                                   x-text="course.description"></p></td>
                                                            <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                                <p class="text-black dark:text-white"
                                                                   x-text="course.typeOfCourse"></p></td>
                                                        </tr>
                                                    </template>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </div>
                </div>
                <!-- ====== Subscrition End -->
            </div>
        </main>
        <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->

</body>
<tg:footer/>
<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('learnerSubscriptions', () => ({
            subscriptions: [],

            init() {
                window.refreshSubscriptions = this.fetchSubscriptions.bind(this);
                this.fetchSubscriptions();
            },

            fetchSubscriptions() {
                const url = `<%=Routes.LEARN_SUBCRIPTIONS%>?learnerId=${apprenant.id}`;

                fetch(url, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        this.subscriptions = data;
                    })
                    .catch(error => console.error('Error:', error));
            },

            unSubcr(subscription) {
                const data = {
                    learnerId: '${apprenant.id}',
                    subscriptionId: subscription.id,
                    subscriptionName:subscription.name
                };

                window.unSubcrForm(data);
            },
        }));
    });
</script>

</html>