package com.cal.controlleurs.langs;

import com.cal.models.Language;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import static com.cal.Routes.LANG_LIST;

@WebServlet({LANG_LIST})
public class LangListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        List<Language> languages = em.createQuery("SELECT a FROM Language a", Language.class).getResultList();
        request.setAttribute("languages", languages);
        request.getRequestDispatcher("WEB-INF/langs/list.jsp")
                .forward(request, response);
        em.close();
    }
}

