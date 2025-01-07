<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tgc" tagdir="/WEB-INF/tags/chats" %>

<div class="hidden h-full flex-col xl:flex xl:w-1/4">
    <!-- ====== Chat List Start -->
    <div class="sticky flex items-center justify-between border-b border-stroke px-6 py-7.5 dark:border-strokedark">
        <%--        <h3 class="text-lg font-medium text-black dark:text-white 2xl:text-xl">--%>
        <%--            Active Conversations--%>
        <%--            <span class="rounded-md border-[.5px] border-stroke bg-gray-2 px-2 py-0.5 text-base font-medium text-black dark:border-strokedark dark:bg-boxdark-2 dark:text-white 2xl:ml-4">7</span>--%>
        <%--        </h3>--%>
        <div></div>
        <tgc:new-chat/>
    </div>
    <div class="flex max-h-full flex-col overflow-auto p-5">
        <div class="no-scrollbar max-h-full space-y-2.5 overflow-auto">

            <template x-for="conversation in conversations"
                      :key="conversation.id">
                <div @click="selectConversation(conversation.id)"

                     :class="{ 'bg-gray-100 dark:bg-meta-4': (selectedConversationId === conversation.id) }"
                     class="flex cursor-pointer items-center rounded px-4 py-2 hover:bg-gray-2 dark:hover:bg-strokedark">
                    <div class="relative mr-3.5 h-11 w-11 rounded-full">
                        <img src="${pageContext.request.contextPath}/src/images/user/profile.svg"
                             alt="profile"
                             class="h-full w-full object-cover object-center">
                        <span
                                class="absolute bottom-0 right-0 block h-3 w-3 rounded-full border-2 border-gray-2 bg-success"></span>
                    </div>
                    <div class="w-full">
                        <h5 class="text-sm font-medium text-black dark:text-white"
                            >
                            <span x-text="conversation.name"></span>
                            <button x-show="conversation.isGroup" class="inline-flex rounded-full border border-primary px-1 ml-1 text-xs font-medium text-primary hover:opacity-80">
                              Group
                            </button>
                        </h5>
                        <p class="text-sm font-medium"
                           x-text="conversation.messages.length > 0 ? conversation.messages[conversation.messages.length - 1].content : 'Pas de messages'">
                        </p>
                    </div>
                </div>
            </template>
        </div>
    </div>
    <!-- ====== Chat List End -->
</div>