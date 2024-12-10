<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tgc" tagdir="/WEB-INF/tags/chats" %>
<%
    User user = (User) session.getAttribute("user");
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
            <%--            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">--%>
            <div class="mx-auto max-w-screen-2xl">


                <%--                <!-- Breadcrumb Start -->--%>
                <%--                <tg:breadcrumb name="Message"/>--%>
                <%--                <!-- Breadcrumb End -->--%>
                <div class="h-[calc(100vh-80px)] p-1 overflow-hidden">
                    <%--                <div class="h-[calc(100vh-186px)] overflow-hidden sm:h-[calc(100vh-174px)]">--%>
                    <div class="h-full rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark xl:flex">
                        <tgc:sidebar/>
                        <div class="flex h-full flex-col border-l border-stroke dark:border-strokedark xl:w-3/4">
                            <!-- ====== Chat Box Start -->
                            <tgc:header/>
                            <div
                                    id="chat"
                                    class="no-scrollbar max-h-full space-y-3.5 overflow-auto px-6 py-7.5">
                                <template x-for="(messages, date) in groupedMessages" :key="date">
                                    <div>
                                        <div class="my-6 top-0 sticky ">
                                            <div class="flex justify-center items-center">
                                                <div class=" bg-white dark:bg-boxdark px-3 border dark:border-strokedark border-stroke rounded">
                                                    <span x-text="date"></span>
                                                </div>
                                            </div>
                                        </div>

                                        <template x-for="message in messages" :key="message.id">
                                            <div
                                                    :class="{ 'ml-auto': message.isCurrentUser, 'max-w-125': !message.isCurrentUser }">
                                                <template x-if="!message.isCurrentUser">
                                                    <div class="mb-2.5">
                                                        <p class="mb-1 text-sm font-medium">
                                                            <span x-text="message.firstName"></span> <span
                                                                x-text="message.lastName"></span>
                                                        </p>
                                                        <div
                                                                class="mb-1 rounded-2xl rounded-tl-none bg-gray px-5 py-3 dark:bg-boxdark-2">
                                                            <p class="font-medium" x-text="message.content">
                                                            </p>
                                                        </div>
                                                        <p class="text-xs font-medium"
                                                           x-text="message.timestamp"></p>
                                                    </div>
                                                </template>

                                                <template x-if="message.isCurrentUser">
                                                    <div class="ml-auto max-w-125 mb-2.5">
                                                        <div
                                                                class="mb-1 rounded-2xl rounded-br-none bg-primary px-5 py-3">
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
            messages: [],
            newMessage: '',
            ws: null,
            learnerId: Number('<%=user.getId()%>'),
            firstName: '<%=user.getFirstname()%>',
            lastName: '<%=user.getLastname()%>',
            init() {
                this.ws = new WebSocket("ws://localhost:8011/<%=Routes.CHAT%>");

                this.ws.onmessage = (event) => {
                    const messageData = JSON.parse(event.data);
                    const messageDate = new Date(messageData.created_at);
                    if (messageDate.toString() !== 'Invalid Date') {
                        this.messages.push({
                            id: messageData.id,
                            learnerId: messageData.learnerId,
                            firstName: messageData.firstName,
                            lastName: messageData.lastName,
                            content: messageData.content,
                            // Affiche l'heure, minute, seconde
                            timestamp: messageDate.toTimeString().split(' ')[0],
                            date: messageDate.toLocaleDateString(),
                            isCurrentUser: messageData.learnerId === this.learnerId
                        });
                    }
                    console.log(messageData)

                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });
                };
            },
            sendMessage() {
                if (this.newMessage.trim() !== '') {
                    const messageContent = this.newMessage;
                    const messageDate = new Date();

                    // Utilisation d'un ID temporaire
                    const tempId = Date.now();

                    this.messages.push({
                        id: tempId,
                        learnerId: this.learnerId,
                        firstName: this.firstName,
                        lastName: this.lastName,
                        content: messageContent,
                        // Affiche l'heure, minute, seconde
                        timestamp: messageDate.toTimeString().split(' ')[0],
                        date: messageDate.toLocaleDateString(),
                        isCurrentUser: true
                    });

                    // Envoyer le message via WebSocket
                    const message = JSON.stringify({
                        learnerId: this.learnerId,
                        firstName: this.firstName,
                        lastName: this.lastName,
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
            }
        }));
    });
</script>

</body>

</html>
