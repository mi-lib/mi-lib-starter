How to cmake build mi-lib (on Windows Visual Studio)
===

Visual Studio を使用して mi-lib を使用したい人向け。


## 1. 依存環境

### 1.1. 統合開発環境

- Visual Studio >= 2022

### 1.2. コンパイラ

- llvm clang (``clang_x64_x64``) のみ対応( バージョン >= 19.1.5 で確認済み)。  
  Visual Studio C++ 起動時に標準使用されるコンパイラ(``msvc_x64_x64``) は未対応。

&nbsp;

## 2. ダウンロード手順

### 2.1. Visual Studio インストーラをダウンロード

- 一応 Visual Studio Community 2022 では動作確認済み

### 2.2. Visual Studio オプションのインストール

- インストーラにて、C/C++ 関連のパッケージを一通りインストールしておく。  
- 特に、cmake のパッケージ、llvm clang のパッケージをインストールしておくこと。  

### 2.3. mi-lib パッケージのダウンロード

1. コマンドプロンプトを開き、本リポジトリのトップディレクトリへ移動しておく。
2. トップディレクトリから以下のようにバッチファイルを実行。  
    ```
    > scripts\win-download.bat
    ``` 

このバッチファイルの内部処理では、もしもリポジトリのフォルダが何もなければクローンし、そうではなく既にリポジトリのフォルダが存在していればzipをダウンロードしフォルダへ展開する。

- 成功すれば、以下のリポジトリ群がトップディレクトリにダウンロードされる。
  - libxml2
  - zeda
  - zm
  - zeo
  - neuz
  - dzco
  - roki
  - roki-fd
  - roki-gl
  - glew
  - glfw
- また同じく成功すれば、以下の各リポジトリパスへ ``XXX_export.h`` が自動生成される。
  - ``zeda/include/zeda/zeda_export.h``
  - ``zm/include/zm/zm_export.h``
  - ``zeo/include/zeo/zeo_export.h``
  - ``nuez/include/neuz/neuz_export.h``
  - ``dzco/include/dzco/dzco_export.h``
  - ``roki/include/roki/roki_export.h``
  - ``roki-fd/include/roki_fd/roki_fd_export.h``
  - ``roki-gl/include/roki_gl/roki_gl_export.h``

&nbsp;

## 3. ビルド手順
### 3.1. Visual Studioの起動＆設定

- Visual Studio メニューバーの  [ツール(T)] --> [オプション(O)...] にてオプション画面を開く。  
  - オプション画面の左側項目から [CMake] を選択。  
  - 「CMake構成ファイル」の [CMakeプリセットを常に使用する] を選択。  
    これにより、本リポジトリに登録されている CMakePreset.json が優先的に使用されるはず。  

### 3.2. Cmake

- Visual Studio メニューバーの [プロジェクト(P)] --> [キャッシュを構成する] (古いキャッシュが残っていれば[キャッシュをを削除し再構成する(D)]) を選択し、Cmake キャッシュを構成する。  

### 3.3. ビルド

- Visual Studio メニューバーの [ビルド(B)] --> [すべてビルド] (古い成果物が残っていれば[すべてリビルド]) を選択し、ビルドする。   
  - 出力先  
    ビルドが成功すれば、ライブラリ、テスト/サンプル/アプリの実行ファイルはそれぞれ以下の中へ生成される。　　
    - ライブラリ : ``build/lib/``
    - 実行ファイル : ``build/bin/``

&nbsp;

## 4. サンプルの実行手順

以下にサンプルの実行手順の例示。

### 4.1. (パターン1) Visual Studio 上でのデバッグ実行

#### (1) サンプル mi-lib-starter_test を実行する場合

以下の手順により、サンプル ``mi-lib-starter_test.exe`` をデバッグ実行する。

1. Visual Studio メニューバーの [スタートアップアイテムの選択] のプルダウンメニューを開く。  
  「 ``mi-lib-starter_test.exe (...)`` 」 を選択しておく。  
2. [F5]キー 、もしくは 「▷」マーク、もしくはメニューバーの [デバッグ(D)] --> [デバッグの開始] により実行する。  

#### (2) それ以外のテスト/サンプル/アプリを実行する場合

1. Visual Studio メニューバーの [スタートアップアイテムの選択] のプルダウンメニューを開く。  
  実行したい「 ``(実行ファイル名).exe (...)`` 」 を選択。  
2. 生成されたライブラリへの実行時パスを通す。  
  Visual Studio では、実行時の設定を ``.vs\launch.vs.json`` に記載するらしい。  
    - Visual Studioのメニューバーの [デバッグ] --> [(実行ファイル名)のデバッグおよび起動の設定] を選択する。設定ファイル ``launch.vs.json`` が開かれ、実行ファイルの設定が一部自動的に記述される。  
    - その設定に対し、以下のように新たに項目 `env` を追記。キーに環境変数 `PATH` を追記し、値にライブラリへの実行時パスを追記しておく。  
      ```json
      {
        "type": "default",
        "project": "...",
        "projectTarget": "...",
        "name": "(実行ファイル名).exe (...)",
        "env": {
          "PATH": "%PATH%;${workspaceRoot}\\build\\lib"
        }
      }
      ```  
3. [F5]キー 、もしくは 「▷」マーク、もしくはメニューバーの [デバッグ(D)] --> [デバッグの開始] により実行する。


### 4.2. (パターン2) コマンドプロンプト上での実行

Windowsの環境変数 `%PATH%` にライブラリへのパスを通して実行する。そのためのバッチファイルを用意している。

1. コマンドプロンプトを開き、本リポジトリのトップディレクトリへ移動しておく。
2. ``win-set-env-path.bat`` を一度実行する。  
    たとえば、トップディレクトリから以下のように実行する。  
    ```
    > scripts\win-set-env-path.bat
    ```  
    これにより、生成されたライブラリへのパスが環境変数 PATH に追記される(本コマンドプロンプト端末上でのみ有効)。    
3. テスト/サンプル/アプリを実行する。  
    たとえば、トップディレクトリから以下のように実行する。  
    ```
    > build\bin\実行ファイルパス.exe
    ```

&nbsp;

<div style="text-align: right;">以上</div>