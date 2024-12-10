<%@ page import="com.cal.Routes" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html lang="fr">
<tg:head-style title="Centre D'apprentissage Linguistique"/>

<body class="antialiased bg-boxdark">
<!-- navbar -->
<div class="w-full text-gray-700">
    <div class="flex flex-col max-w-screen-xl px-8 mx-auto md:items-center md:justify-between md:flex-row">
        <div class="flex flex-row items-center justify-between">
            <div class="relative md:mt-2">
                <img class="h-28 z-40 "
                     src="${pageContext.request.contextPath}/src/images/logo.png" alt="CAL Center">
            </div>
        </div>

    </div>
</div>
<div>
    <div class="max-w-screen-xl px-8 mx-auto flex flex-col lg:flex-row items-start">
        <div class="flex flex-col w-full lg:w-6/12 justify-center lg:pt-4 items-start text-center lg:text-left mb-5 md:mb-0">
            <h1 class="my-4 text-5xl font-bold leading-tight text-darken">
                <span class="text-primary">CAL Center</span>
            </h1>
            <p class="leading-normal text-2xl mb-8">
                Centre d'appretissage linguistique
            </p>
            <div  class="w-full md:flex items-center justify-center lg:justify-start md:space-x-5">
                <a href="${pageContext.request.contextPath}<%=Routes.LOGIN%>" class="lg:mx-0 bg-primary text-white text-xl font-bold rounded-full py-4 px-9 focus:outline-none transform transition hover:scale-110 duration-300 ease-in-out">
                    Se connecter
                </a>
            </div>
        </div>
        <div class="w-full lg:w-6/12 lg:-mt-10 relative" id="girl">
            <img class="w-10/12 mx-auto 2xl:-mb-20"
                 src="${pageContext.request.contextPath}/src/images/girl.png" />
        </div>
    </div>

    <div class="text-white -mt-14 sm:-mt-24 lg:-mt-36 z-40 relative">
        <svg class="xl:h-40 xl:w-full" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120" preserveAspectRatio="none">
            <path class="bg-primary fill-primary" d="M600,112.77C268.63,112.77,0,65.52,0,7.23V120H1200V7.23C1200,65.52,931.37,112.77,600,112.77Z" fill="currentColor"></path>
        </svg>
        <div class="bg-cream w-full h-20 -mt-px"></div>
    </div>
</div>

</body>
</html>