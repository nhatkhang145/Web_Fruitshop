package controller;

import dal.DBContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class SaleExpirationListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                try {
                    DBContext.get().useHandle(handle -> handle.createUpdate(
                        "UPDATE products SET sale_price = 0, sale_price_expires_at = NULL " +
                        "WHERE sale_price_expires_at IS NOT NULL AND sale_price_expires_at <= NOW()"
                    ).execute());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, 0, 15, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
    }
}
