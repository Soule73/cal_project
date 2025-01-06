<%@tag pageEncoding="UTF-8" %>

<div x-data="{openDropDown: false}" class="relative ">
    <button @click="openDropDown = !openDropDown">
        <svg class="fill-current" width="16" height="16"
             viewBox="0 0 16 16" fill="none"
             xmlns="http://www.w3.org/2000/svg">
            <path
                    d="M2 10C3.10457 10 4 9.10457 4 8C4 6.89543 3.10457 6 2 6C0.89543 6 0 6.89543 0 8C0 9.10457 0.89543 10 2 10Z"
                    fill=""></path>
            <path
                    d="M8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z"
                    fill=""></path>
            <path
                    d="M14 10C15.1046 10 16 9.10457 16 8C16 6.89543 15.1046 6 14 6C12.8954 6 12 6.89543 12 8C12 9.10457 12.8954 10 14 10Z"
                    fill=""></path>
        </svg>
    </button>
    <div x-show="openDropDown"
         @click.outside="openDropDown = false"
         class="absolute right-0 top-full md:min-w-min space-y-1 rounded-sm border border-stroke bg-white p-1.5 shadow-default dark:border-strokedark dark:bg-boxdark"
         x-cloak>
        <button @click="openNewChatModal"
                class="flex w-full items-center gap-2 rounded-sm px-4 py-1.5 text-left text-sm hover:bg-gray dark:hover:bg-meta-4">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" width="16" height="16">
                <path d="M8.75 3.75a.75.75 0 0 0-1.5 0v3.5h-3.5a.75.75 0 0 0 0 1.5h3.5v3.5a.75.75 0 0 0 1.5 0v-3.5h3.5a.75.75 0 0 0 0-1.5h-3.5v-3.5Z"/>
            </svg>
            Nouvelle conversation
        </button>
    </div>
</div>
