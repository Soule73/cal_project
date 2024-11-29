<%@tag%>
<div x-data="{modalOpen: false}" x-cloak>
    <button @click="modalOpen = true" class="rounded-md bg-primary px-9 py-3 font-medium text-white ">
       Ajouter un cours
    </button>
    <div x-show="modalOpen" x-transition="" class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
        <div @click.outside="modalOpen = false" class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
            <jsp:doBody />
        </div>
    </div>
</div>