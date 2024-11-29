<%@ tag %>
<%@ tag import="com.cal.Routes" %>
<!-- ===== Sidebar Start ===== -->
<aside
        :class="sidebarToggle ? 'translate-x-0' : '-translate-x-full'"
        class="absolute left-0 top-0 z-9999 flex h-screen w-72.5 flex-col overflow-y-hidden bg-black duration-300 ease-linear dark:bg-boxdark lg:static lg:translate-x-0"
        @click.outside="sidebarToggle = false"
>
    <!-- SIDEBAR HEADER -->
    <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
        <a href="${pageContext.request.contextPath}/" >
            <div class=" bg-primmary rounded-xl p-2 text-white text-2xl font-bold ">
                CAL Center
            </div>
        </a>

        <button
                class="block lg:hidden"
                @click.stop="sidebarToggle = !sidebarToggle"
        >
            <svg
                    class="fill-current"
                    width="20"
                    height="18"
                    viewBox="0 0 20 18"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
            >
                <path
                        d="M19 8.175H2.98748L9.36248 1.6875C9.69998 1.35 9.69998 0.825 9.36248 0.4875C9.02498 0.15 8.49998 0.15 8.16248 0.4875L0.399976 8.3625C0.0624756 8.7 0.0624756 9.225 0.399976 9.5625L8.16248 17.4375C8.31248 17.5875 8.53748 17.7 8.76248 17.7C8.98748 17.7 9.17498 17.625 9.36248 17.475C9.69998 17.1375 9.69998 16.6125 9.36248 16.275L3.02498 9.8625H19C19.45 9.8625 19.825 9.4875 19.825 9.0375C19.825 8.55 19.45 8.175 19 8.175Z"
                        fill=""
                />
            </svg>
        </button>
    </div>
    <!-- SIDEBAR HEADER -->

    <div
            class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
    >
        <!-- Sidebar Menu -->
        <nav
                class="mt-5 px-4 py-4 lg:mt-9 lg:px-6"
                x-data="{selected: $persist('Dashboard')}"
        >
            <!-- Menu Group -->
            <div>
                <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">MENU</h3>

                <ul class="mb-6 flex flex-col gap-1.5">


                    <!-- Menu Item Dashboard -->
                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="#"
                                @click="selected = (selected === 'Dashboard' ? '':'Dashboard')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Dashboard') && (page === 'Dashboard') }"
                                :class="page === 'profile' && 'bg-graydark'"
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
                                 width="18"
                                 height="18"
                                 class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z" />
                            </svg>


                            Tableau de bord
                        </a>
                    </li>
                    <!-- Menu Item Dashboard -->

                    <!-- Menu Item Apprenants -->
                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="#"
                                @click.prevent="selected = (selected === 'Apprenants' ? '':'Apprenants')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Apprenants') || (page === 'listApprenants' || page === 'addApprenant') }"
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                 width="18"
                                 height="18"
                                 stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" />
                            </svg>


                            Apprenants

                            <svg
                                    class="absolute right-4 top-1/2 -translate-y-1/2 fill-current"
                                    :class="{ 'rotate-180': (selected === 'Apprenants') }"
                                    width="20"
                                    height="20"
                                    viewBox="0 0 20 20"
                                    fill="none"
                                    xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M4.41107 6.9107C4.73651 6.58527 5.26414 6.58527 5.58958 6.9107L10.0003 11.3214L14.4111 6.91071C14.7365 6.58527 15.2641 6.58527 15.5896 6.91071C15.915 7.23614 15.915 7.76378 15.5896 8.08922L10.5896 13.0892C10.2641 13.4147 9.73651 13.4147 9.41107 13.0892L4.41107 8.08922C4.08563 7.76378 4.08563 7.23614 4.41107 6.9107Z"
                                        fill=""
                                />
                            </svg>
                        </a>

                        <!-- Dropdown Menu Start -->
                        <div
                                class="translate transform overflow-hidden"
                                :class="(selected === 'Apprenants') ? 'block' :'hidden'"
                        >
                            <ul class="mb-5.5 mt-4 flex flex-col gap-2.5 pl-6">
                                <li>
                                    <a
                                            class="group relative flex items-center gap-2.5 rounded-md px-4 font-medium text-bodydark2 duration-300 ease-in-out hover:text-white"
                                            href="${pageContext.request.contextPath}<%= Routes.LEARNER_LIST %>"
                                            :class="page === 'listApprenants' && '!text-white'"
                                    >Liste</a
                                    >
                                </li>
                                <li>
                                    <a
                                            class="group relative flex items-center gap-2.5 rounded-md px-4 font-medium text-bodydark2 duration-300 ease-in-out hover:text-white"
                                            href="${pageContext.request.contextPath}<%= Routes.LEARNER_CREATE %>"
                                            :class="page === 'addApprenant' && '!text-white'"
                                    >Ajouter un apprenant</a
                                    >
                                </li>

                            </ul>
                        </div>
                        <!-- Dropdown Menu End -->
                    </li>
                    <!--End Menu Item Apprenants -->

                    <!-- Menu Item languages -->
                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="#"
                                @click.prevent="selected = (selected === 'Languages' ? '':'Languages')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Languages') || (page === 'listLanguages' || page === 'addLanguage') }"
                        >
                            <svg
                                    width="20"
                                    height="20"
                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m10.5 21 5.25-11.25L21 21m-9-3h7.5M3 5.621a48.474 48.474 0 0 1 6-.371m0 0c1.12 0 2.233.038 3.334.114M9 5.25V3m3.334 2.364C11.176 10.658 7.69 15.08 3 17.502m9.334-12.138c.896.061 1.785.147 2.666.257m-4.589 8.495a18.023 18.023 0 0 1-3.827-5.802" />
                            </svg>



                            Langues

                            <svg
                                    class="absolute right-4 top-1/2 -translate-y-1/2 fill-current"
                                    :class="{ 'rotate-180': (selected === 'Apprenants') }"
                                    width="20"
                                    height="20"
                                    viewBox="0 0 20 20"
                                    fill="none"
                                    xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M4.41107 6.9107C4.73651 6.58527 5.26414 6.58527 5.58958 6.9107L10.0003 11.3214L14.4111 6.91071C14.7365 6.58527 15.2641 6.58527 15.5896 6.91071C15.915 7.23614 15.915 7.76378 15.5896 8.08922L10.5896 13.0892C10.2641 13.4147 9.73651 13.4147 9.41107 13.0892L4.41107 8.08922C4.08563 7.76378 4.08563 7.23614 4.41107 6.9107Z"
                                        fill=""
                                />
                            </svg>
                        </a>

                        <!-- Dropdown Menu Start -->
                        <div
                                class="translate transform overflow-hidden"
                                :class="(selected === 'Languages') ? 'block' :'hidden'"
                        >
                            <ul class="mb-5.5 mt-4 flex flex-col gap-2.5 pl-6">
                                <li>
                                    <a
                                            class="group relative flex items-center gap-2.5 rounded-md px-4 font-medium text-bodydark2 duration-300 ease-in-out hover:text-white"
                                            href="${pageContext.request.contextPath}<%= Routes.LANG_LIST %>"
                                            :class="page === 'listLanguages' && '!text-white'"
                                    >Liste</a
                                    >
                                </li>
                                <li>
                                    <a
                                            class="group relative flex items-center gap-2.5 rounded-md px-4 font-medium text-bodydark2 duration-300 ease-in-out hover:text-white"
                                            href="${pageContext.request.contextPath}<%= Routes.LANG_CREATE %>"
                                            :class="page === 'addLanguage' && '!text-white'"
                                    >Ajouter une langue</a
                                    >
                                </li>

                            </ul>
                        </div>
                        <!-- Dropdown Menu End -->
                    </li>
                    <!--End Menu Item Apprenants -->
                </ul>
            </div>


        </nav>
        <!-- Sidebar Menu -->
    </div>
</aside>

<!-- ===== Sidebar End ===== -->