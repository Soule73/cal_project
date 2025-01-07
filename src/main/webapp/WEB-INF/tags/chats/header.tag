<%@tag pageEncoding="UTF-8" %>

<div
        class="sticky flex items-center justify-between border-b border-stroke px-6 py-4.5 dark:border-strokedark" style="z-index:0 !important;">
    <div @click="openManageMembersModal()" class="flex cursor-pointer items-center">
        <div
                class="mr-4.5 h-13 w-full max-w-13 overflow-hidden rounded-full">
            <svg class="h-full w-full object-cover object-center" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" >
                <path class="dark:stroke-white" stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 0 1 .865-.501 48.172 48.172 0 0 0 3.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0 0 12 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018Z" />
            </svg>

        </div>

        <div>
            <h5 class="font-medium text-black dark:text-white" x-text="selectedConversation ? selectedConversation.name : 'Sélectionnez une conversation'"></h5>

        <%--p class="text-sm font-medium">Reply to message</p>--%>
        </div>
    </div>

</div>