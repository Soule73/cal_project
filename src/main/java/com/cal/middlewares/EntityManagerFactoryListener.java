package com.cal.middlewares;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class EntityManagerFactoryListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("languageCenterPU");
        sce.getServletContext().setAttribute("EntityManagerFactory", emf);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        EntityManagerFactory emf = (EntityManagerFactory) sce.getServletContext().getAttribute("EntityManagerFactory");
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}

