import pandas as pd
import matplotlib.pyplot as plt

# 1. 데이터 불러오기
url = "https://raw.githubusercontent.com/greatsong/modudata/main/data/seoul.csv"
df = pd.read_csv(url, encoding='cp949')

# 2. 데이터 전처리
# 날짜 컬럼을 datetime 형식으로 변환 후 연도 추출
df['날짜'] = pd.to_datetime(df['날짜'])
df['연도'] = df['날짜'].dt.year

# 결측치 제거 후 연도별 평균기온 계산
df_clean = df.dropna(subset=['평균기온(℃)'])
annual_temp = df_clean.groupby('연도')['평균기온(℃)'].mean().reset_index()

# 3. 한글 폰트 및 마이너스 기호 설정 (운영체제별 맞춤)
plt.rc('font', family='Malgun Gothic')  # Windows: Malgun Gothic, Mac: AppleGothic
plt.rcParams['axes.unicode_minus'] = False

# 4. 그래프 그리기
plt.figure(figsize=(12, 6))
plt.plot(annual_temp['연도'], annual_temp['평균기온(℃)'], 
         color='#e74c3c', marker='o', markersize=3, linewidth=1.5, label='연평균 기온')

# 추세선 추가 (온도 상승 경향 파악)
z = pd.np.polyfit(annual_temp['연도'], annual_temp['평균기온(℃)'], 1)
p = pd.np.poly1d(z)
plt.plot(annual_temp['연도'], p(annual_temp['연도']), 
         color='black', linestyle='--', linewidth=1.5, label='장기 추세선')

# 축 및 제목 설정
plt.title('서울의 연평균 기온 변화 추이', fontsize=16, pad=15)
plt.xlabel('연도', fontsize=12)
plt.ylabel('평균 기온 (℃)', fontsize=12)
plt.grid(True, linestyle=':', alpha=0.7)
plt.legend(loc='upper left')

plt.tight_layout()
plt.show()
