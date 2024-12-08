<%@ tag import="com.cal.Routes" %>
<%@tag pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div x-data="addSubscriptionForm()" x-init="init()" x-cloak>
    <button @click="openModal" class="rounded-md bg-primary px-9 py-3 font-medium text-white">
        Ajouter un abonnement
    </button>
    <div x-show="modalOpen" x-transition="" x-cloak
         class="fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5"
        >
        <div @click.outside="closeModal"
             class="w-full w-max rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
            <h4 x-show="!successMessage" class="mb-6 text-xl font-bold text-black dark:text-white">Abonnements
                Disponibles</h4>

            <div x-show="!successMessage" class="flex flex-wrap justify-around">
                <c:forEach var="subscription" items="${subscriptionsList}">
                    <div class="relative rounded-sm border border-stroke bg-white p-6 shadow-default dark:border-strokedark dark:bg-boxdark md:p-9 xl:p-11.5">
                        <span class="mb-2.5 block text-title-sm2 font-bold text-black dark:text-white">${subscription.name}</span>
                        <h3>
                            <span class="text-xl font-medium text-black dark:text-white">$</span>
                            <span class="text-title-xxl2 font-bold text-black dark:text-white">${subscription.price}</span>
                        </h3>
                        <h4 class="mb-5 mt-7.5 text-lg font-medium text-black dark:text-white">${subscription.description}</h4>
                        <div>${subscription.type}</div>
                        <button @click="setSubscription('${subscription.id}', '${subscription.name}', '${subscription.price}', '${subscription.type}', '${subscription.description}')"
                                class="mt-9 flex rounded-md border border-primary px-9 py-3 font-medium text-primary hover:bg-primary hover:text-white">
                            Sélectionner
                        </button>
                    </div>
                </c:forEach>
            </div>

            <!-- Success Message -->
            <div id="successMessage" x-show="successMessage" class="flex w-full">
                <div class="flex w-max w-max mx-auto p-4 w-full items-center justify-center rounded-full bg-[#34D399]">
                    <svg width="56" height="50" viewBox="0 0 16 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15.2984 0.826822L15.2868 0.811827L15.2741 0.797751C14.9173 0.401867 14.3238 0.400754 13.9657 0.794406L5.91888 9.45376L2.05667 5.2868C1.69856 4.89287 1.10487 4.89389 0.747996 5.28987C0.417335 5.65675 0.417335 6.22337 0.747996 6.59026L0.747959 6.59029L0.752701 6.59541L4.86742 11.0348C5.14445 11.3405 5.52858 11.5 5.89581 11.5C6.29242 11.5 6.65178 11.3355 6.92401 11.035L15.2162 2.11161C15.5833 1.74452 15.576 1.18615 15.2984 0.826822Z"
                              fill="white" stroke="white"></path>
                    </svg>
                </div>
                <div class="w-full">
                    <h5 class="mb-3 text-lg font-bold text-black dark:text-[#34D399]">Succès</h5>
                    <p x-text="successMessage" class="text-base leading-relaxed text-body"></p>
                </div>
            </div>
            <div x-show="successMessage" @click="closeModal" class="flex justify-end">
                <button type="submit"
                        class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                    Fermer
                </button>
            </div>
        </div>
    </div>
</div>


<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('addSubscriptionForm', () => ({
            formTitle: "Ajouter un abonnement",
            submitBtnText: "Ajouter",
            modalOpen: false,

            subscriptions: [],
            selectedSubscription: {},

            init() {
                // Initialisation et récupération des abonnements si nécessaire
            },

            setSubscription(id, name, price, type, description) {
                this.selectedSubscription = {
                    subscriptionId: id,
                    learnerId: '${apprenant.id}',

                };
                console.log('Subscription selected:', this.selectedSubscription);
                this.submitSubscription();
            },

            submitSubscription() {
                const data = JSON.stringify(this.selectedSubscription);
                console.log("Sending data:", data);

                fetch('<%=Routes.LEARN_SUBCRIPTIONS%>', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: data
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            this.error = data.error;
                            console.log("Errors received:", this.error);
                        } else {
                            this.successMessage = "L'abonnement a été ajouté avec succès!";
                            // Appeler la méthode globale pour rafraîchir les abonnements
                            window.refreshSubscriptions();
                        }
                    })
                    .catch(error => console.error('Error:', error));
            },
            openModal() {
                // this.resetForm();
                this.modalOpen = true;
                this.successMessage = '';
            },

            closeModal() {
                this.modalOpen = false;
                // this.resetForm();
                this.successMessage = '';
            },

        }));
    });
</script>
