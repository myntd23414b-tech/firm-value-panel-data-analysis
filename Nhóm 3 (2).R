getwd()
du_lieu <- read.csv("DATA - Nhóm 3.csv", header = TRUE, sep=",")
du_lieu

library(plm)
pdata <- pdata.frame(du_lieu, index = c("NAME", "YEAR"))

#Thống kê mô tả
library(psych)
describe(pdata)
#Thống kê mô tả cho thấy biến TOBIN_Q và GROWTH có skewness cao
#--> lệch phải nhiều --> tiến hành xử lý outliner

#XỬ LÝ OUTLINER
df_clean <- as.data.frame(pdata)
vars <- c("TOBIN_Q", "GROWTH", "TANG", "SIZE", "ROA")
df_clean[vars] <- lapply(df_clean[vars], function(x) {
  
  # chuyển sang numeric
  x <- as.numeric(as.character(x))
  
  # tính ngưỡng 2.5% và 97.5%
  qnt <- quantile(x, probs = c(0.025, 0.975), na.rm = TRUE)
  
  # thay giá trị ngoài ngưỡng
  x[x < qnt[1]] <- qnt[1]
  x[x > qnt[2]] <- qnt[2]
  
  return(x)
})
#Ma trận tương quan
library(correlation)
library(dplyr)
variable <- df_clean %>% 
  select(TOBIN_Q, GROWTH, TANG, SIZE, ROA)
result <- correlation(variable)
matrix_star <- summary(result, stars = TRUE)

print(matrix_star)

#Thống kê mô tả mới
describe(df_clean[, vars])

pdata_clean <- pdata.frame(df_clean, index = c("NAME", "YEAR"))

#skewness của TOBIN_Q vẫn bị lệch phải --> sử dụng mô hình log - lin

#TRỰC QUAN HÓA
library(ggplot2)
library(gridExtra)
library(grid)

#Histogram của TOBIN_Q sau khi đã Winsorize
p1 <- ggplot(df_clean, aes(x = TOBIN_Q)) +
  geom_histogram(aes(y = ..density..), bins = 20, 
                 fill = "darkgreen", color = "white", alpha = 0.7) +
  geom_density(color = "violet", linewidth = 1) +
  labs(title = "TOBIN_Q (Sau Winsorize)", 
       x = "Giá trị Tobin's Q", y = "Mật độ") +
  theme_minimal()

#Histogram của TOBIN_Q sau khi đã lấy LOG
p2 <- ggplot(df_clean, aes(x = log(TOBIN_Q))) +
  geom_histogram(aes(y = ..density..), bins = 20, 
                 fill = "steelblue", color = "white", alpha = 0.7) +
  geom_density(color = "darkred", linewidth = 1) +
  labs(title = "log(TOBIN_Q)", 
       x = "Giá trị Log(Tobin's Q)", y = "Mật độ") +
  theme_minimal()

#Ghép 2 biểu đồ
combined_plot <- grid.arrange(p1, p2, ncol = 2,
             top = textGrob("So sánh phân phối Tobin's Q trước và sau khi log",
                            gp = gpar(fontsize = 16, fontface = "bold")))
ggsave("Histogram_TobinQ.jpg", combined_plot, width = 10, height = 5, dpi = 300)
#Chạy OLS
pols <- plm(log(TOBIN_Q) ~ TANG + SIZE + ROA + GROWTH, 
            data = pdata_clean, model = "pooling")
summary(pols)

#Kiểm tra đa cộng tuyến
library(car)
v_o <- vif(pols)
vif_df <- data.frame(
  VIF = round(v_o, 3)
)
print(vif_df)
#Chạy FEM
fem <- plm(log(TOBIN_Q) ~ TANG + SIZE + ROA + GROWTH, 
           data = pdata_clean, model = "within")
summary(fem)

#Chạy REM
rem <- plm(log(TOBIN_Q) ~ TANG + SIZE + ROA + GROWTH, 
           data = pdata_clean, model = "random")
summary(rem)

library(lmtest)
#Kiểm định chọn fem hoặc pols
chow_test <- pFtest(fem, pols)
print(chow_test)

#Kiểm định hausman chọn fem hoặc rem
hausman_test <- phtest(fem, rem)
print(hausman_test)

#Xuất bảng kết quả 3 mô hình
library(stargazer)
stargazer(pols, fem, rem, type = "text")

##KIỂM ĐỊNH SAU FEM
#PHƯƠNG SAI SAI SỐ THAY ĐỔI:
bptest(fem)
#TỰ TƯƠNG QUAN
pbgtest(fem)
#PHỤ THUỘC CHÉO
pcdtest(fem, test = "cd")
#KIỂM ĐỊNH NỘI SINH
# Bước 1: Hồi quy bậc 1 (first-stage) với FEM
pdata_clean$TANG_lag <- lag(pdata_clean$TANG, 1)
first_stage <- plm(TANG ~ TANG_lag + SIZE + ROA + GROWTH,
                   data = pdata_clean,
                   model = "within")
summary(first_stage)

# Lấy phần dư từ first-stage
used_rows <- rownames(model.frame(first_stage))
pdata_clean <- pdata[used_rows, ]
pdata_clean$resid_first_stage <- as.numeric(residuals(first_stage))

# Bước 2: Hồi quy FEM gốc nhưng thêm phần dư first-stage
dwh_model <- plm(TOBIN_Q ~ TANG + SIZE + ROA + GROWTH + resid_first_stage,
                 data = pdata_clean,
                 model = "within")
summary(dwh_model)

stargazer(dwh_model, type = "text", 
          title = "Kết quả hồi quy tác động cố định (FE)",
          dep.var.labels = c("Tobin's Q"),
          digits = 3, out = "ketqua.txt")
#--> Mô hình không bị nội sinh

#Chữa khuyết tật cho mô hình
#Dùng Driscoll - Kraay
library(sandwich)
DK <- coeftest(fem, vcov = vcovSCC(fem, type = "HC1"))
print(DK)

library(modelsummary)
install.packages("pandoc")
modelsummary(
  fem,
  vcov = function(x) vcovSCC(x, type = "HC1"),
  stars = TRUE,
  gof_omit = "IC|Log|Adj|F",
  output = "Ket_qua.docx"
)
