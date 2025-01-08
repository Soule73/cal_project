<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tgc" tagdir="/WEB-INF/tags/chats" %>
<%
    User user = (User) session.getAttribute("user");
    boolean isAdmin = user.getRoles().stream().anyMatch(role -> role.getName().equals("ADMIN"));

%>
<%@ page import="com.cal.Routes" %>
<%@ page import="com.cal.models.User" %>
<!DOCTYPE html>
<html lang="fr">

<tg:head-style title="Message">

</tg:head-style>

<body
        x-data="{ page: 'message', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
        x-init="
darkMode = JSON.parse(localStorage.getItem('darkMode'));
selected = 'message';
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
        <main x-data="chat">
            <!-- Gestion de la conversation -->

            <div x-show="manageMembersModalOpen" x-transition
                 class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
                <div @click.outside="closeManageMembersModal"
                     class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
                    <h3 class=" pb-6 text-gray-700 md:text-xl fond-bold dark:text-white">

                        <span x-show="selectedConversation?.isGroup">Membres du groupe</span>
                        <span x-show="!selectedConversation?.isGroup">Contacte</span>
                    </h3>

                    <!-- membres -->
                    <div class="py-4">
                        <template x-if="selectedConversation?.members?.length > 0">
                            <template x-for="user in selectedConversation?.members" :key="user.id">
                                <div class="flex cursor-pointer items-center rounded px-4 py-2 hover:bg-gray-2 dark:hover:bg-strokedark">
                                    <div class="relative mr-3.5 h-11 w-11 rounded-full">
                                        <img src="${pageContext.request.contextPath}/src/images/user/profile.svg"
                                             alt="profile"
                                             class="h-full w-full object-cover object-center">
                                        <span class="absolute bottom-0 right-0 block h-3 w-3 rounded-full border-2 border-gray-2 bg-success"></span>
                                    </div>
                                    <div class="w-full">
                                        <div class="flex items-center justify-between p-2 border-gray-300 dark:border-gray-600">
                                            <div>
                                                <h5 class="font-medium text-start text-black dark:text-white"
                                                    x-text="user.fullName"></h5>
                                                <p class="text-sm font-medium text-gray-600 dark:text-gray-400"
                                                   x-text="user.email"></p>
                                            </div>

                                            <template
                                                    x-if="selectedConversation.isGroup && selectedConversation.members.find(member => member.id === userId && member.is_admin)">
                                                <button
                                                        x-show="user.id !== <%= user.getId() %>"
                                                        @click="removeMember(user.id)"
                                                        class="text-red-400 hover:text-red-600"
                                                        title="Supprimer l'utilisateur">
                                                    <svg class="fill-current" width="18" height="18" viewBox="0 0 18 18"
                                                         fill="none" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M13.7535 2.47502H11.5879V1.9969C11.5879 1.15315 10.9129 0.478149 10.0691 0.478149H7.90352C7.05977 0.478149 6.38477 1.15315 6.38477 1.9969V2.47502H4.21914C3.40352 2.47502 2.72852 3.15002 2.72852 3.96565V4.8094C2.72852 5.42815 3.09414 5.9344 3.62852 6.1594L4.07852 15.4688C4.13477 16.6219 5.09102 17.5219 6.24414 17.5219H11.7004C12.8535 17.5219 13.8098 16.6219 13.866 15.4688L14.3441 6.13127C14.8785 5.90627 15.2441 5.3719 15.2441 4.78127V3.93752C15.2441 3.15002 14.5691 2.47502 13.7535 2.47502ZM7.67852 1.9969C7.67852 1.85627 7.79102 1.74377 7.93164 1.74377H10.0973C10.2379 1.74377 10.3504 1.85627 10.3504 1.9969V2.47502H7.70664V1.9969H7.67852ZM4.02227 3.96565C4.02227 3.85315 4.10664 3.74065 4.24727 3.74065H13.7535C13.866 3.74065 13.9785 3.82502 13.9785 3.96565V4.8094C13.9785 4.9219 13.8941 5.0344 13.7535 5.0344H4.24727C4.13477 5.0344 4.02227 4.95002 4.02227 4.8094V3.96565ZM11.7285 16.2563H6.27227C5.79414 16.2563 5.40039 15.8906 5.37227 15.3844L4.95039 6.2719H13.0785L12.6566 15.3844C12.6004 15.8625 12.2066 16.2563 11.7285 16.2563Z"
                                                              fill=""/>
                                                        <path d="M9.00039 9.11255C8.66289 9.11255 8.35352 9.3938 8.35352 9.75942V13.3313C8.35352 13.6688 8.63477 13.9782 9.00039 13.9782C9.33789 13.9782 9.64727 13.6969 9.64727 13.3313V9.75942C9.64727 9.3938 9.33789 9.11255 9.00039 9.11255Z"
                                                              fill=""/>
                                                        <path d="M11.2502 9.67504C10.8846 9.64692 10.6033 9.90004 10.5752 10.2657L10.4064 12.7407C10.3783 13.0782 10.6314 13.3875 10.9971 13.4157C11.0252 13.4157 11.0252 13.4157 11.0533 13.4157C11.3908 13.4157 11.6721 13.1625 11.6721 12.825L11.8408 10.35C11.8408 9.98442 11.5877 9.70317 11.2502 9.67504Z"
                                                              fill=""/>
                                                        <path d="M6.72245 9.67504C6.38495 9.70317 6.1037 10.0125 6.13182 10.35L6.3287 12.825C6.35683 13.1625 6.63808 13.4157 6.94745 13.4157C6.97558 13.4157 6.97558 13.4157 7.0037 13.4157C7.3412 13.3875 7.62245 13.0782 7.59433 12.7407L7.39745 10.2657C7.39745 9.90004 7.08808 9.64692 6.72245 9.67504Z"
                                                              fill=""/>
                                                    </svg>
                                                </button>
                                            </template>

                                            <button x-show="user.is_admin && selectedConversation?.isGroup" class="inline-flex rounded-full border border-primary px-3 py-1 text-sm font-medium text-primary hover:opacity-80">
                                                Admin
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </template>
                        </template>
                    </div>


                </div>
            </div>

            <!-- Nouveau Conversation group -->
            <% if (isAdmin) { %>
            <div x-show="newGroupModalOpen" x-transition
                 class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
                <div @click.outside="closeNewGroupModal"
                     class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
                    <h3 class=" pb-6 text-gray-700 md:text-xl fond-bold dark:text-white">
                        Créer un nouveau groupe
                    </h3>
                    <div class="sticky mb-7">

                        <input type="text" x-model="newGroupName" placeholder="Nom du groupe"
                               class="w-full rounded border border-stroke bg-gray-2 py-2.5 pl-5 pr-10 text-sm outline-none focus:border-primary dark:border-strokedark dark:bg-boxdark-2">

                    </div>
                    <div class=" mt-2">
                        <input type="text" x-model="searchTerm"
                               @keyup.enter="searchUsers"
                               placeholder="Rechercher des utilisateurs"
                               class="w-full rounded border border-stroke bg-gray-2 py-2.5 pl-5 pr-10 text-sm outline-none focus:border-primary dark:border-strokedark dark:bg-boxdark-2"
                               spellcheck="false" data-ms-editor="true">
                        <button @click="searchUsers" class="absolute right-4 top-1/2 -translate-y-1/2">
                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M8.25 3C5.3505 3 3 5.3505 3 8.25C3 11.1495 5.3505 13.5 8.25 13.5C11.1495 13.5 13.5 11.1495 13.5 8.25C13.5 5.3505 11.1495 3 8.25 3ZM1.5 8.25C1.5 4.52208 4.52208 1.5 8.25 1.5C11.9779 1.5 15 4.52208 15 8.25C15 11.9779 11.9779 15 8.25 15C4.52208 15 1.5 11.9779 1.5 8.25Z"
                                      fill="#637381"></path>
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M11.957 11.958C12.2499 11.6651 12.7247 11.6651 13.0176 11.958L16.2801 15.2205C16.573 15.5133 16.573 15.9882 16.2801 16.2811C15.9872 16.574 15.5124 16.574 15.2195 16.2811L11.957 13.0186C11.6641 12.7257 11.6641 12.2508 11.957 11.958Z"
                                      fill="#637381"></path>
                            </svg>
                        </button>
                    </div>
                    <!-- resultats -->
                    <div class="py-4">

                        <template x-show="!noResultOrError">
                            <div class=" text-center text-lg font-bold py-5 ">
                                <span x-text="noResultOrError"></span>
                            </div>
                        </template>
                        <template x-if="searchResults.length > 0">
                            <template x-for="user in searchResults" :key="user.id">
                                <div class="flex cursor-pointer items-center rounded px-4 py-2 hover:bg-gray-2 dark:hover:bg-strokedark">
                                    <div class="relative mr-3.5 h-11 w-11 rounded-full">
                                        <img src="${pageContext.request.contextPath}/src/images/user/profile.svg"
                                             alt="profile"
                                             class="h-full w-full object-cover object-center">
                                        <span
                                                class="absolute bottom-0 right-0 block h-3 w-3 rounded-full border-2 border-gray-2 bg-success"></span>
                                    </div>
                                    <div class="w-full">
                                        <div class="flex items-center justify-between p-2 border-gray-300 dark:border-gray-600">
                                            <div>
                                                <h5 class="font-medium text-start text-black dark:text-white"
                                                    x-text="user.name"></h5>
                                                <p class="text-sm font-medium text-gray-600 dark:text-gray-400"
                                                   x-text="user.email"></p>
                                            </div>
                                            <label>
                                                <input type="checkbox" :value="user.id"
                                                       @change="toggleUserSelection(user.id)"
                                                       class="ml-4 p-2 bg-green-500 text-white rounded">
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </template>
                        </template>
                    </div>
                    <div class=" flex item-center justify-end  w-full">

                        <button @click="closeNewGroupModal()"
                                class="mr-4 inline-flex items-center justify-center rounded-md border border-primary px-4 py-2 text-center font-medium text-primary hover:bg-opacity-90">
                            Annuler
                        </button>
                        <button @click="createGroup()"
                                class="inline-flex items-center justify-center bg-primary px-4 py-2 text-center font-medium text-white hover:bg-opacity-90">
                            Créer le groupe
                        </button>
                    </div>

                </div>
            </div>
            <% } %>
            <!-- Nouvelle Conversation privée -->
            <div x-show="newChatModalOpen" x-transition
                 class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
                <div @click.outside="closeNewChatModal"
                     class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
                    <h3 class=" pb-6 text-gray-700 md:text-xl fond-bold dark:text-white">Démarrez une nouvelle
                        discussion</h3>
                    <div class="sticky mb-7">
                        <input type="text" x-model="searchTerm"
                               @keyup.enter="searchUsers"
                               placeholder="Rechercher un utilisateur..."
                               class="w-full rounded border border-stroke bg-gray-2 py-2.5 pl-5 pr-10 text-sm outline-none focus:border-primary dark:border-strokedark dark:bg-boxdark-2"
                               spellcheck="false" data-ms-editor="true">
                        <button @click="searchUsers" class="absolute right-4 top-1/2 -translate-y-1/2">
                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M8.25 3C5.3505 3 3 5.3505 3 8.25C3 11.1495 5.3505 13.5 8.25 13.5C11.1495 13.5 13.5 11.1495 13.5 8.25C13.5 5.3505 11.1495 3 8.25 3ZM1.5 8.25C1.5 4.52208 4.52208 1.5 8.25 1.5C11.9779 1.5 15 4.52208 15 8.25C15 11.9779 11.9779 15 8.25 15C4.52208 15 1.5 11.9779 1.5 8.25Z"
                                      fill="#637381"></path>
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M11.957 11.958C12.2499 11.6651 12.7247 11.6651 13.0176 11.958L16.2801 15.2205C16.573 15.5133 16.573 15.9882 16.2801 16.2811C15.9872 16.574 15.5124 16.574 15.2195 16.2811L11.957 13.0186C11.6641 12.7257 11.6641 12.2508 11.957 11.958Z"
                                      fill="#637381"></path>
                            </svg>
                        </button>
                    </div>
                    <!-- Recherche d'Utilisateurs -->
                    <div class="by-4">

                        <template x-show="!noResultOrError">
                            <div class=" text-center text-lg font-bold py-5 ">
                                <span x-text="noResultOrError"></span>
                            </div>
                        </template>
                        <template x-if="searchResults.length > 0">
                            <div class="mt-4">
                                <template x-for="user in searchResults" :key="user.id">
                                    <div
                                            class="flex cursor-pointer items-center rounded px-4 py-2 hover:bg-gray-2 dark:hover:bg-strokedark">
                                        <div class="relative mr-3.5 h-11 w-11 rounded-full">
                                            <img src="${pageContext.request.contextPath}/src/images/user/profile.svg"
                                                 alt="profile"
                                                 class="h-full w-full object-cover object-center">
                                            <span
                                                    class="absolute bottom-0 right-0 block h-3 w-3 rounded-full border-2 border-gray-2 bg-success"></span>
                                        </div>
                                        <div class="w-full">
                                            <div class="flex items-center justify-between p-2 border-gray-300 dark:border-gray-600">
                                                <div>
                                                    <h5 class="font-medium text-start text-black dark:text-white"
                                                        x-text="user.name"></h5>
                                                    <p class="text-sm font-medium text-gray-600 dark:text-gray-400"
                                                       x-text="user.email"></p>

                                                </div>
                                                <button title="Démarrer une conversation"
                                                        @click="startConversation(user.id)"
                                                        class="ml-4 p-2 bg-green-500 text-white rounded">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"
                                                         fill="currentColor" class="size-4">
                                                        <path fill-rule="evenodd"
                                                              d="M1 8.74c0 .983.713 1.825 1.69 1.943.904.108 1.817.19 2.737.243.363.02.688.231.85.556l1.052 2.103a.75.75 0 0 0 1.342 0l1.052-2.103c.162-.325.487-.535.85-.556.92-.053 1.833-.134 2.738-.243.976-.118 1.689-.96 1.689-1.942V4.259c0-.982-.713-1.824-1.69-1.942a44.45 44.45 0 0 0-10.62 0C1.712 2.435 1 3.277 1 4.26v4.482Zm3-3.49a.75.75 0 0 1 .75-.75h6.5a.75.75 0 0 1 0 1.5h-6.5A.75.75 0 0 1 4 5.25ZM4.75 7a.75.75 0 0 0 0 1.5h2.5a.75.75 0 0 0 0-1.5h-2.5Z"
                                                              clip-rule="evenodd"/>
                                                    </svg>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                </template>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
            <%--            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">--%>
            <div class="mx-auto max-w-screen-2xl">

                <div class="h-[calc(100vh-80px)] p-1 overflow-hidden">
                    <div class="h-full rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark xl:flex">
                        <tgc:sidebar/>
                        <div class="flex h-full flex-col border-l border-stroke dark:border-strokedark xl:w-3/4">
                            <!-- ====== Chat Box Start -->
                            <tgc:header/>
                            <div
                                    id="chat"
                                    class="no-scrollbar chat-bg min-h-[calc(100vh-(80px+94px+86px))] max-h-full space-y-3.5 overflow-auto px-6 py-7.5">
                                <template x-if="messages.length === 0">
                                    <div class="h-full w-full flex items-center justify-center flex-col">
                                        <img src="${pageContext.request.contextPath}/src/svg/quick_chat.svg"
                                             class=" w-32 md:w-64"
                                             alt="Aucun message">
                                        <p class="mt-4 p-4 rounded-md bg-white dark:bg-boxdark">Aucun message</p>
                                    </div>
                                </template>
                                <template x-if="messages.length > 0">
                                    <template x-for="(messages, date) in groupedMessages" :key="date">
                                        <div>
                                            <div class="my-6 sticky top-0">
                                                <div class="flex justify-center items-center">
                                                    <div class="bg-white dark:bg-boxdark px-3 border dark:border-strokedark border-stroke rounded">
                                                        <span x-text="date"></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <template x-for="message in messages" :key="message.id">
                                                <div :class="{ 'ml-auto': message.isCurrentUser, 'max-w-125': !message.isCurrentUser }">
                                                    <template x-if="!message.isCurrentUser">
                                                        <div class="mb-2.5">
                                                            <p class="mb-1 text-sm font-medium">
                                                                <span x-text="message.firstName"></span>
                                                                <span x-text="message.lastName"></span>
                                                            </p>
                                                            <div class="mb-1 rounded-2xl rounded-tl-none bg-gray px-5 py-3 dark:bg-boxdark-2">
                                                                <p class="font-medium" x-text="message.content"></p>
                                                            </div>
                                                            <p class="text-xs font-medium"
                                                               x-text="message.timestamp"></p>
                                                        </div>
                                                    </template>

                                                    <template x-if="message.isCurrentUser">
                                                        <div class="ml-auto max-w-125 mb-2.5">
                                                            <div class="mb-1 rounded-2xl rounded-br-none bg-primary px-5 py-3">
                                                                <p class="font-medium text-white"
                                                                   x-text="message.content"></p>
                                                            </div>
                                                            <p class="text-right text-xs font-medium"
                                                               x-text="message.timestamp"></p>
                                                        </div>
                                                    </template>
                                                </div>
                                            </template>
                                        </div>
                                    </template>
                                </template>
                            </div>
                            <tgc:footer/>
                            <!-- ====== Chat Box End -->
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!-- ===== Main Content End ===== -->

    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->
<tg:footer/>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('chat', () => ({
            conversations: [],
            messages: [],
            searchTerm: '',
            noResultOrError: null,
            searchResults: [],
            selectedUsers: new Set(),
            newGroupName: '',
            newMessage: '',
            selectedConversationId: null,
            ws: null,
            userId: Number('<%=user.getId()%>'),
            firstName: '<%=user.getFirstname()%>',
            lastName: '<%=user.getLastname()%>',
            newChatModalOpen: false,
            newGroupModalOpen: false,
            manageMembersModalOpen: false,
            hasConnected: false,

            openNewChatModal() {
                this.newChatModalOpen = true;
                this.noResultOrError = null;

            },

            closeNewChatModal() {
                this.newChatModalOpen = false;
                this.noResultOrError = null;

            },

            openNewGroupModal() {
                this.searchUsers(true);
                this.newGroupModalOpen = true;
                this.noResultOrError = null;
                this.selectedUsers.clear();
            },

            closeNewGroupModal() {
                this.newGroupModalOpen = false;
                this.noResultOrError = null;
            },

            openManageMembersModal() {
                this.manageMembersModalOpen = true;
            },

            closeManageMembersModal() {
                this.manageMembersModalOpen = false;
            },

            toggleUserSelection(userId) {
                if (this.selectedUsers.has(userId)) {
                    this.selectedUsers.delete(userId);
                } else {
                    this.selectedUsers.add(userId);
                }
            },

            init() {
                this.ws = new WebSocket("ws://localhost:${sockerPort}<%=Routes.CHAT%>");

                this.ws.onopen = () => {
                    this.hasConnected = true;
                };
                this.ws.close = () => {
                    this.hasConnected = false;
                };

                this.ws.onmessage = (event) => {
                    const data = JSON.parse(event.data);

                    if (data.type === 'startConversation' || data.type === 'createGroup') {
                        const newConversation = {
                            id: data.conversation.id,
                            name: data.conversation.name,
                            isGroup: data.conversation.isGroup,
                            messages: [],
                            members: [],
                        };
                        this.conversations.push(newConversation);
                        this.selectConversation(newConversation.id);
                    } else if (data.messages) {
                        const conversation = {
                            id: data.id,
                            name: data.name,
                            isGroup: data.isGroup,
                            messages: data.messages.map(messageData => {
                                const messageDate = new Date(messageData.created_at);
                                return {
                                    id: messageData.id,
                                    userId: messageData.userId,
                                    firstName: messageData.firstName,
                                    lastName: messageData.lastName,
                                    content: messageData.content,
                                    timestamp: messageDate.toTimeString().split(' ')[0],
                                    date: messageDate.toLocaleDateString(),
                                    conversationId: messageData.conversationId,
                                    isCurrentUser: messageData.userId === this.userId
                                };
                            }),
                            members: data.members
                        };
                        this.conversations.push(conversation);
                        if (!this.conversations) {
                            this.selectConversation(conversation.id);
                        }
                    } else if (data.type === 'removeMember') {
                        const conversation = this.conversations.find(convo => convo.id === data.conversationId);
                        if (conversation) {
                            if (data.memberId === this.userId) {
                                // L'utilisateur courant a été supprimé, retiré la conversation
                                this.conversations = this.conversations.filter(convo => convo.id !== data.conversationId);
                                if (this.selectedConversationId === data.conversationId) {
                                    this.selectedConversationId = null;
                                    this.messages = [];
                                }
                            } else {
                                // Retirer seulement l'utilisateur concerné de la liste des membres
                                conversation.members = conversation.members.filter(member => member.id !== data.memberId);
                            }
                        }
                    } else {
                        const messageDate = new Date(data.created_at);
                        const message = {
                            id: data.id,
                            userId: data.userId,
                            firstName: data.firstName,
                            lastName: data.lastName,
                            content: data.content,
                            timestamp: messageDate.toTimeString().split(' ')[0],
                            date: messageDate.toLocaleDateString(),
                            conversationId: data.conversationId,
                            isCurrentUser: data.userId === this.userId
                        };

                        const conversation = this.conversations.find(convo => convo.id === data.conversationId);
                        if (conversation) {
                            conversation.messages.push(message);
                        }

                        if (this.hasConnected && message.userId !== this.userId) {
                            this.playNotificationSound();
                        }
                    }

                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });
                };

                this.selectedConversationId = parseInt(localStorage.getItem("selectedConversationId"));
            },

            playNotificationSound() {
                const audio = new Audio("${pageContext.request.contextPath}/src/notification.mp3");
                audio.play();
            },

            searchUsers(init = false) {
                if (init || this.searchTerm.length > 1) {
                    fetch('/group-user-search', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: "searchTerm=" + this.searchTerm
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.length > 0) {
                                this.searchResults = data;
                            } else {
                                this.noResultOrError = "Aucun résultat trouvé";
                            }
                        })
                        .catch(error => {
                            this.noResultOrError = "Une erreur s'est produite lors de la recherche";
                            console.error('Erreur de recherche:', error);
                        });
                } else {
                    this.noResultOrError = null;
                    this.searchResults = [];
                }
            },

            createGroup() {
                const selectedUserIds = Array.from(this.selectedUsers);
                if (selectedUserIds.length > 0 && this.newGroupName.trim() !== '') {
                    const message = JSON.stringify({
                        type: 'createGroup',
                        userId: this.userId,
                        groupName: this.newGroupName,
                        memberIds: selectedUserIds
                    });
                    this.ws.send(message);
                    this.closeNewGroupModal();
                }
            },

            addMembers() {
                const selectedUserIds = Array.from(this.selectedUsers);
                if (selectedUserIds.length > 0 && this.selectedConversationId !== null) {
                    const message = JSON.stringify({
                        type: 'addMember',
                        userId: this.userId,
                        conversationId: this.selectedConversationId,
                        memberIds: selectedUserIds
                    });
                    this.ws.send(message);
                    this.closeManageMembersModal();
                }
            },

            removeMember(userId) {
                if (this.selectedConversationId !== null) {
                    const message = JSON.stringify({
                        type: 'removeMember',
                        userId: this.userId,
                        conversationId: this.selectedConversationId,
                        memberId: userId
                    });
                    this.ws.send(message);

                    const conversation = this.conversations.find(convo => convo.id === this.selectedConversationId);
                    if (conversation) {
                        conversation.members = conversation.members.filter(member => member.id !== userId);
                    }
                }
            },

            selectConversation(conversationId) {
                this.selectedConversationId = conversationId;
                localStorage.setItem("selectedConversationId", conversationId);
                const conversation = this.conversations.find(convo => convo.id === conversationId);
                this.messages = conversation ? conversation.messages : [];

                this.$nextTick(() => {
                    this.scrollToBottom();
                });
            },

            sendMessage() {
                if (this.newMessage.trim() !== '' && this.selectedConversationId !== null) {
                    const messageContent = this.newMessage;
                    const messageDate = new Date();
                    const tempId = Date.now();

                    this.messages.push({
                        id: tempId,
                        userId: this.userId,
                        firstName: this.firstName,
                        lastName: this.lastName,
                        content: messageContent,
                        timestamp: messageDate.toTimeString().split(' ')[0],
                        date: messageDate.toLocaleDateString(),
                        conversationId: this.selectedConversationId,
                        isCurrentUser: true
                    });

                    const message = JSON.stringify({
                        type: 'sendMessage',
                        userId: this.userId,
                        conversationId: this.selectedConversationId,
                        content: messageContent,
                        created_at: messageDate.toISOString()
                    });

                    this.ws.send(message);
                    this.newMessage = '';

                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });
                }
            },

            scrollToBottom() {
                const chatContainer = document.getElementById('chat');
                chatContainer.scrollTop = chatContainer.scrollHeight;
            },

            get groupedMessages() {
                return this.messages.reduce((groups, message) => {
                    const date = message.date;
                    if (!groups[date]) {
                        groups[date] = [];
                    }
                    groups[date].push(message);
                    return groups;
                }, {});
            },

            get selectedConversation() {
                return this.conversations.find(convo => convo.id === this.selectedConversationId);
            }
        }));
    });
</script>

</body>

</html>
