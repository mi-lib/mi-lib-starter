How to cmake build mi-lib (on Windows Visual Studio)
===

Visual Studio を使用して mi-lib を使用したい人向け。


## 依存環境

### 統合開発環境

- Visual Studio >= 2022


### コンパイラ

- llvm clang (``clang_x64_x64``) のみ対応( バージョン >= 12.0.1 相当)。  
  Visual Studio C++ 起動時に標準使用されるコンパイラ(``msvc_x64_x64``) では現状未対応

&nbsp;

## ビルド手順

### 1. Visual Studio インストーラをダウンロード

- 一応 Visual Studio Community 2022 では動作確認済み

### 2. Visual Studio オプションのインストール

- インストーラにて、C/C++ 関連のパッケージを一通りインストールしておく。  
- 特に、cmake のパッケージ、clang のパッケージをインストールしておくこと。  

### 3. mi-lib パッケージのダウンロード

1. コマンドプロンプトを開き、本リポジトリのトップディレクトリに移動。
2. トップディレクトリにて以下のようにバッチファイルを実行。   
    ```
    > scripts/mi-lib-clone.bat
    ``` 

- 成功すれば、以下のリポジトリ群がトップディレクトリにクローンされる。
  - zeda
  - zm
  - zeo
  - neuz
  - dzco
  - roki
  - roki-fd

### 4. Visual Studioの起動＆設定

- Visual Studio メニューバーの  [ツール(T)] --> [オプション(O)...] にてオプション画面を開く。  
  - オプション画面の左側項目から [CMake] を選択。  
  - 「CMake構成ファイル」の [CMakeプリセットを使用しない] を選択。  
    これにより、デフォルト作成・使用環境の CMakePreset.json ではなく、本リポジトリに登録されている CMakeSettings.json が優先的に使用されるはず。  

### 5. Cmake

- Visual Studio メニューバーの [プロジェクト(P)] --> [キャッシュを構成する] (古いキャッシュが残っていれば[キャッシュをを削除し再構成する(D)]) を選択し、Cmake キャッシュを構成する。  

### 6. ビルド

- Visual Studio メニューバーの [ビルド(B)] --> [すべてビルド] (古い成果物が残っていれば[すべてリビルド]) を選択し、ビルドを実行する。  


<div style="text-align: right;">以上</div>