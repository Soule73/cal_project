<%@ tag %>
<%@ tag import="com.cal.Routes" %>
<!-- ===== Sidebar Start ===== -->
<aside
        :class="sidebarToggle ? 'translate-x-0' : '-translate-x-full'"
        class="absolute left-0 top-0 z-9999 flex h-screen w-72.5 flex-col overflow-y-hidden bg-black duration-300 ease-linear dark:bg-boxdark lg:static lg:translate-x-0"
        @click.outside="sidebarToggle = false">
    <!-- SIDEBAR HEADER -->
    <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
        <a href="${pageContext.request.contextPath}/">
            <div class=" bg-primmary rounded-xl p-2 text-white text-2xl font-bold ">
                CAL Center
            </div>
        </a>

        <button
                class="block lg:hidden"
                @click.stop="sidebarToggle = !sidebarToggle">
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
            class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear">
        <!-- Sidebar Menu -->
        <nav
                class="mt-5 px-4 py-4 lg:mt-9 lg:px-6"
                x-data="{selected: $persist('Dashboard')}">
            <!-- Menu Group -->
            <div>
                <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">MENU</h3>

                <ul class="mb-6 flex flex-col gap-1.5">

                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="<%=Routes.LEARNER_LIST%>"
                                @click="selected = (selected === 'listApprenants' ? '':'listApprenants')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'listApprenants') }"
                                :class="page === 'listApprenants' && 'bg-graydark'">

                            <svg
                                    width="18"
                                    height="18"
                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z" />
                            </svg>

                            Apprenants
                        </a>
                    </li>


                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1
                                duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="<%=Routes.LANG_LIST%>"
                                @click="selected = (selected === 'listLanguages' ? '':'listLanguages')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'listLanguages') }"
                                :class="page === 'listLanguages' && 'bg-graydark'">
                            <svg
                                    width="18"
                                    height="18"
                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m10.5 21 5.25-11.25L21 21m-9-3h7.5M3 5.621a48.474 48.474 0 0 1 6-.371m0 0c1.12 0 2.233.038 3.334.114M9 5.25V3m3.334 2.364C11.176 10.658 7.69 15.08 3 17.502m9.334-12.138c.896.061 1.785.147 2.666.257m-4.589 8.495a18.023 18.023 0 0 1-3.827-5.802" />
                            </svg>

                            Langues
                        </a>
                    </li>

                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="<%=Routes.ROOM_LIST%>"
                                @click="selected = (selected === 'listRooms' ? '':'listRooms')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'listRooms') && (page === 'listRooms') }"
                                :class="page === 'profile' && 'bg-graydark'">

                            <svg
                                    width="18"
                                    height="18"
                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                    stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"/>
                            </svg>

                            Salle
                        </a>
                    </li>

                    <li>
                        <a
                                class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
                                href="<%=Routes.SUBCRIPTION_LIST%>"
                                @click="selected = (selected === 'listSubscriptions' ? '':'listSubscriptions')"
                                :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'listSubscriptions') && (page === 'listSubscriptions') }"
                                :class="page === 'profile' && 'bg-graydark'">
                            <svg
                                    width="18"
                                    height="18"
                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                    stroke-width="1.5" stroke="currentColor" class="size-6">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M14.25 7.756a4.5 4.5 0 1 0 0 8.488M7.5 10.5h5.25m-5.25 3h5.25M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
                            </svg>
                            Abonnements
                        </a>
                    </li>


                </ul>
            </div>
        </nav>
        <!-- Sidebar Menu -->
    </div>
</aside>

<!-- ===== Sidebar End ===== -->