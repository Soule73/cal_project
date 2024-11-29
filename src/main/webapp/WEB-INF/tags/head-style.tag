<%@ tag description="Tag for head section with dynamic title and additional content" pageEncoding="UTF-8"%>
<%@ attribute name="title" required="true" %>

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${title} - CAL</title>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico">

    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <jsp:doBody />
    <script>
        // Fonction pour masquer le message après 5 secondes
        function hideMessage(id) {
            setTimeout(function () {
                const element = document.getElementById(id);
                if (element) {
                    element.style.display = 'none';
                }
            }, 5000);
            // 5000 millisecondes = 5 secondes
        }
    </script>
</head>
