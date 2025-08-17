#include "headers.hpp"

// Standard C++ headers needed for operations
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <sys/stat.h>

// Include the existing headers from other directory
#include "../scripts/filey.hpp"
#include "../scripts/input.hpp"
#include "../scripts/palette.hpp"

const ColorScheme CATPPUCCIN_MOCHA({"#45475a", "#f38ba8", "#a6e3a1", "#f9e2af",
                                    "#89b4fa", "#f5c2e7", "#94e2d5", "#a6adc8",
                                    "#585b70", "#f38ba8", "#a6e3a1", "#f9e2af",
                                    "#89b4fa", "#f5c2e7", "#94e2d5", "#bac2de"},
                                   {"#1e1e2e", "#cdd6f4", "#f5e0dc", "#1e1e2e",
                                    "#353749", "#cdd6f4"});

const ColorScheme CATPPUCCIN_LATTE({"#5c5f77", "#d20f39", "#40a02b", "#df8e1d",
                                    "#1e66f5", "#ea76cb", "#179299", "#acb0be",
                                    "#6c6f85", "#d20f39", "#40a02b", "#df8e1d",
                                    "#1e66f5", "#ea76cb", "#179299", "#bcc0cc"},
                                   {"#eff1f5", "#4c4f69", "#dc8a78", "#eff1f5",
                                    "#d8dae1", "#4c4f69"});

const ColorScheme GRUVBOX_DARK({"#1b1b1b", "#ea6962", "#a9b665", "#d8a657",
                                "#7daea3", "#d3869b", "#89b482", "#d4be98",
                                "#32302f", "#ea6962", "#a9b665", "#d8a657",
                                "#7daea3", "#d3869b", "#89b482", "#d4be98"},
                               {"#282828", "#d4be98", "#d4be98", "#282828",
                                "#3c3836", "#d4be98"});

const ColorScheme GRUVBOX_LIGHT({"#f2e5bc", "#c14a4a", "#6c782e", "#b47109",
                                 "#45707a", "#945e80", "#4c7a5d", "#654735",
                                 "#f3eac7", "#c14a4a", "#6c782e", "#b47109",
                                 "#45707a", "#945e80", "#4c7a5d", "#654735"},
                                {"#fbf1c7", "#654735", "#654735", "#fbf1c7",
                                 "#f2e5bc", "#654735"});

const ColorScheme DRACULA_DARK({"#21222c", "#ff5555", "#50fa7b", "#f1fa8c",
                                "#bd93f9", "#ff79c6", "#8be9fd", "#f8f8f2",
                                "#6272a4", "#ff6e6e", "#69ff94", "#ffffa5",
                                "#d6acff", "#ff92df", "#a4ffff", "#ffffff"},
                               {"#282a36", "#f8f8f2", "#f8f8f2", "#282a36",
                                "#44475a", "#f8f8f2"});

ColorScheme getColorSchemeByName(const std::string& schemeName) {
  if (schemeName == "catppuccin-mocha") {
    return CATPPUCCIN_MOCHA;
  } else if (schemeName == "catppuccin-latte") {
    return CATPPUCCIN_LATTE;
  } else if (schemeName == "gruvbox-dark") {
    return GRUVBOX_DARK;
  } else if (schemeName == "gruvbox-light") {
    return GRUVBOX_LIGHT;
  } else if (schemeName == "dracula") {
    return DRACULA_DARK;
  }
  
  // Fallback to dark theme
  return GRUVBOX_DARK;
}

class InstallWorker : public QObject {
  Q_OBJECT

public slots:
  void performInstallation(const std::vector<std::string> &packages,
                           const std::string &wallpaperPath,
                           const std::string &colorSchemeTheme,
                           const std::string &predefinedScheme,
                           bool generateColorScheme) {
    try {
      emit statusUpdate("Setting up installation...");
      emit progressUpdate(10);

      ColorScheme scheme;
      if (generateColorScheme && !wallpaperPath.empty()) {
        emit statusUpdate("Generating color scheme from wallpaper...");
        emit progressUpdate(20);

        scheme = generateColorSchemeFromImage(wallpaperPath, colorSchemeTheme,
                                              "colorscheme.txt");
        emit statusUpdate("Color scheme generated successfully!");
        emit progressUpdate(40);
      } else if (!predefinedScheme.empty()) {
        emit statusUpdate(QString("Using predefined %1 color scheme...")
                              .arg(QString::fromStdString(predefinedScheme)));
        scheme = getColorSchemeByName(predefinedScheme);
        emit progressUpdate(40);
      } else {
        emit statusUpdate("Using default gruvbox-dark color scheme...");
        scheme = GRUVBOX_DARK;
        emit progressUpdate(40);
      }

      emit statusUpdate("Setting up file paths...");
      FileManager fm;

      ThemeType theme = ThemeType::DARK;
      if (colorSchemeTheme == "light")
        theme = ThemeType::LIGHT;
      else if (colorSchemeTheme == "warm")
        theme = ThemeType::WARM;

      if (!wallpaperPath.empty()) {
        std::string wp = wallpaperPath;
        fm.moveWallpaper(wp);
      }

      fm.setupLocalPath(packages);
      emit progressUpdate(60);

      int packagesProcessed = 0;
      for (const std::string &package_name : packages) {
        emit statusUpdate(QString("Installing %1...")
                              .arg(QString::fromStdString(package_name)));

        std::string trimmed_package =
            setupPackage(package_name, {"dunst", "fastfetch", "fish", "eww",
                                        "ghostty", "vesktop", "waybar", "wofi",
                                        "hypr", "catalyst", "cava"});

        if (trimmed_package == "Not found.") {
          emit statusUpdate(QString("Package %1 not found; skipping.")
                                .arg(QString::fromStdString(package_name)));
          continue;
        }
        
        fm.setupPackageColors(trimmed_package, scheme);
        fm.movePackage(trimmed_package);

        packagesProcessed++;
        int progress = 60 + (packagesProcessed * 30 / packages.size());
        emit progressUpdate(progress);
      }

      emit statusUpdate("Finalizing installation...");
      QProcess::execute("hyprctl", {"reload"});
      if (!wallpaperPath.empty()) {
        QProcess::execute("swww",
                          {"img", QString::fromStdString(wallpaperPath)});
      }

      emit progressUpdate(100);
      emit statusUpdate("Installation complete!");
      emit installationComplete();

    } catch (const std::exception &e) {
      emit installationError(QString::fromStdString(e.what()));
    }
  }

signals:
  void statusUpdate(const QString &message);
  void progressUpdate(int percentage);
  void installationComplete();
  void installationError(const QString &error);

private:
  std::string setupPackage(const std::string &package_name,
                           const std::vector<std::string> &totalPackages) {
    std::string trimmed_package = package_name;
    // Trim whitespace
    trimmed_package.erase(0, trimmed_package.find_first_not_of(" \t\n\r\f\v"));
    trimmed_package.erase(trimmed_package.find_last_not_of(" \t\n\r\f\v") + 1);

    if (std::find(totalPackages.begin(), totalPackages.end(),
                  trimmed_package) != totalPackages.end()) {
      if (trimmed_package == "hypr") {
        trimmed_package = "hyprland";
      }

      std::string dir = "/usr/bin/" + trimmed_package;
      struct stat sb;

      if (stat(dir.c_str(), &sb) == 0) {
        emit statusUpdate(QString("%1 already on system")
                              .arg(QString::fromStdString(trimmed_package)));
      } else if (trimmed_package == "catalyst") {
        std::string cmd =
            "git clone https://github.com/Matercan/catalyst.git && makepkg -si";
        system(cmd.c_str());
      } else {
        std::string cmd;
        if (trimmed_package != "hyprland") {
          cmd = "yay -S " + trimmed_package;
        } else {
          cmd = "yay -S hyprland hyprlock hypridle";
        }
        system(cmd.c_str());
      }

      return trimmed_package;
    } else {
      return "Not found.";
    }
  }
};

class WallpaperPreview : public QLabel {
  Q_OBJECT

public:
  WallpaperPreview(QWidget *parent = nullptr) : QLabel(parent) {
    setFixedSize(200, 150);
    setStyleSheet("QLabel { border: 2px dashed #555; border-radius: 8px; "
                  "background-color: #2a2a2a; }");
    setText("No wallpaper\nselected");
    setAlignment(Qt::AlignCenter);
    setWordWrap(true);
  }

  void setWallpaper(const QString &path) {
    if (path.isEmpty()) {
      setText("No wallpaper\nselected");
      setPixmap(QPixmap());
      return;
    }

    QPixmap pixmap(path);
    if (!pixmap.isNull()) {
      QPixmap scaled =
          pixmap.scaled(size(), Qt::KeepAspectRatio, Qt::SmoothTransformation);
      setPixmap(scaled);
      setText("");
      setStyleSheet(
          "QLabel { border: 2px solid #4CAF50; border-radius: 8px; }");
    } else {
      setText("Invalid image\nfile");
      setStyleSheet("QLabel { border: 2px solid #f44336; border-radius: 8px; "
                    "background-color: #2a2a2a; }");
    }
  }
};

class PackageCheckBox : public QCheckBox {
  Q_OBJECT

public:
  PackageCheckBox(const QString &name, QWidget *parent = nullptr)
      : QCheckBox(name, parent) {
    setStyleSheet(R"(
            QCheckBox {
                font-size: 14px;
                padding: 8px;
                spacing: 10px;
            }
            QCheckBox::indicator {
                width: 18px;
                height: 18px;
                border-radius: 3px;
                border: 2px solid #555;
            }
            QCheckBox::indicator:checked {
                background-color: #4CAF50;
                border-color: #4CAF50;
            }
            QCheckBox::indicator:hover {
                border-color: #777;
            }
        )");
  }
};

class DotfilesInstaller : public QMainWindow {
  Q_OBJECT

public:
  DotfilesInstaller(QWidget *parent = nullptr) : QMainWindow(parent) {
    setupUI();
    setupConnections();
    setupWorkerThread();

    // Apply dark theme
    applyDarkTheme();

    setWindowTitle("Hyprland Dotfiles Installer");
    setMinimumSize(900, 700);
    resize(1100, 800);
  }

private slots:
  void selectWallpaper() {
    QString fileName =
        QFileDialog::getOpenFileName(this, "Select Wallpaper", QDir::homePath(),
                                     "Image Files (*.png *.jpg *.jpeg)");

    if (!fileName.isEmpty()) {
      wallpaperPath->setText(fileName);
      wallpaperPreview->setWallpaper(fileName);

      // Enable color scheme generation when wallpaper is selected
      generateColorScheme->setEnabled(true);
      onColorModeChanged();
    }
  }

  void selectAll() {
    for (auto &checkbox : packageCheckboxes) {
      checkbox->setChecked(true);
    }
  }

  void selectNone() {
    for (auto &checkbox : packageCheckboxes) {
      checkbox->setChecked(false);
    }
  }

  void onColorModeChanged() {
    bool useWallpaper = generateColorScheme->isChecked() && 
                       generateColorScheme->isEnabled();
    bool usePredefined = !generateColorScheme->isChecked();
    
    // Show/hide relevant controls
    themeCombo->setVisible(useWallpaper);
    themeLabel->setVisible(useWallpaper);
    schemeCombo->setVisible(usePredefined);
    schemeLabel->setVisible(usePredefined);
  }

  void startInstallation() {
    std::vector<std::string> selectedPackages;
    for (auto &checkbox : packageCheckboxes) {
      if (checkbox->isChecked()) {
        selectedPackages.push_back(checkbox->text().toStdString());
      }
    }

    if (selectedPackages.empty()) {
      QMessageBox::warning(this, "No Packages Selected",
                           "Please select at least one package to install.");
      return;
    }

    // Disable UI during installation
    setUIEnabled(false);
    progressBar->setValue(0);
    statusLabel->setText("Starting installation...");
    logOutput->clear();

    // Determine color configuration
    std::string wallpaperPathStr = wallpaperPath->text().toStdString();
    std::string colorSchemeThemeStr = themeCombo->currentText().toStdString();
    std::string predefinedSchemeStr = schemeCombo->currentText().toStdString();
    bool generateColors = generateColorScheme->isChecked() && 
                         generateColorScheme->isEnabled();

    // Start installation in worker thread
    QMetaObject::invokeMethod(
        worker, "performInstallation", Qt::QueuedConnection,
        Q_ARG(std::vector<std::string>, selectedPackages),
        Q_ARG(std::string, wallpaperPathStr),
        Q_ARG(std::string, colorSchemeThemeStr),
        Q_ARG(std::string, predefinedSchemeStr),
        Q_ARG(bool, generateColors));
  }

  void onStatusUpdate(const QString &message) {
    statusLabel->setText(message);
    logOutput->append(
        QString("[%1] %2").arg(QTime::currentTime().toString()).arg(message));
  }

  void onProgressUpdate(int percentage) { progressBar->setValue(percentage); }

  void onInstallationComplete() {
    setUIEnabled(true);
    statusLabel->setText("Installation completed successfully!");
    QMessageBox::information(this, "Installation Complete",
                             "Your dotfiles have been installed successfully!");
  }

  void onInstallationError(const QString &error) {
    setUIEnabled(true);
    statusLabel->setText("Installation failed!");
    logOutput->append(QString("[ERROR] %1").arg(error));
    QMessageBox::critical(this, "Installation Error",
                          QString("Installation failed: %1").arg(error));
  }

private:
  void setupUI() {
    auto *centralWidget = new QWidget;
    setCentralWidget(centralWidget);

    auto *mainLayout = new QHBoxLayout(centralWidget);

    // Create splitter for resizable panels
    auto *splitter = new QSplitter(Qt::Horizontal);
    mainLayout->addWidget(splitter);

    // Left panel - Configuration
    auto *leftPanel = new QWidget;
    leftPanel->setMinimumWidth(400);
    setupLeftPanel(leftPanel);
    splitter->addWidget(leftPanel);

    // Right panel - Progress and logs
    auto *rightPanel = new QWidget;
    rightPanel->setMinimumWidth(400);
    setupRightPanel(rightPanel);
    splitter->addWidget(rightPanel);

    splitter->setStretchFactor(0, 1);
    splitter->setStretchFactor(1, 1);
  }

  void setupLeftPanel(QWidget *parent) {
    auto *layout = new QVBoxLayout(parent);

    // Header
    auto *headerLabel = new QLabel("Hyprland Dotfiles Installer");
    headerLabel->setStyleSheet("font-size: 24px; font-weight: bold; color: "
                               "#4CAF50; margin-bottom: 10px;");
    layout->addWidget(headerLabel);

    // Package selection
    auto *packageGroup = new QGroupBox("Select Packages to Install");
    packageGroup->setStyleSheet(
        "QGroupBox { font-weight: bold; margin-top: 10px; }");
    auto *packageLayout = new QVBoxLayout(packageGroup);

    // Package selection buttons
    auto *buttonLayout = new QHBoxLayout;
    auto *selectAllBtn = new QPushButton("Select All");
    auto *selectNoneBtn = new QPushButton("Select None");
    selectAllBtn->setStyleSheet("QPushButton { padding: 5px 15px; }");
    selectNoneBtn->setStyleSheet("QPushButton { padding: 5px 15px; }");
    buttonLayout->addWidget(selectAllBtn);
    buttonLayout->addWidget(selectNoneBtn);
    buttonLayout->addStretch();
    packageLayout->addLayout(buttonLayout);

    // Package checkboxes in a scroll area
    auto *scrollArea = new QScrollArea;
    auto *scrollWidget = new QWidget;
    auto *scrollLayout = new QVBoxLayout(scrollWidget);

    const std::vector<std::string> packages = {
        "ghostty", "hypr",  "fish",     "eww",       "waybar", "wofi",
        "vesktop", "dunst", "catalyst", "fastfetch", "cava"};

    for (const auto &pkg : packages) {
      auto *checkbox = new PackageCheckBox(QString::fromStdString(pkg));
      packageCheckboxes.push_back(checkbox);
      scrollLayout->addWidget(checkbox);
    }

    scrollLayout->addStretch();
    scrollArea->setWidget(scrollWidget);
    scrollArea->setMaximumHeight(200);
    packageLayout->addWidget(scrollArea);

    connect(selectAllBtn, &QPushButton::clicked, this,
            &DotfilesInstaller::selectAll);
    connect(selectNoneBtn, &QPushButton::clicked, this,
            &DotfilesInstaller::selectNone);

    layout->addWidget(packageGroup);

    // Wallpaper section
    auto *wallpaperGroup = new QGroupBox("Wallpaper Configuration");
    wallpaperGroup->setStyleSheet(
        "QGroupBox { font-weight: bold; margin-top: 10px; }");
    auto *wallpaperLayout = new QVBoxLayout(wallpaperGroup);

    auto *wallpaperSelectLayout = new QHBoxLayout;
    wallpaperPath = new QLineEdit;
    wallpaperPath->setPlaceholderText("Select a wallpaper image (optional)...");
    wallpaperPath->setReadOnly(true);
    auto *browseBtn = new QPushButton("Browse");
    browseBtn->setStyleSheet("QPushButton { padding: 8px 20px; }");
    wallpaperSelectLayout->addWidget(wallpaperPath);
    wallpaperSelectLayout->addWidget(browseBtn);
    wallpaperLayout->addLayout(wallpaperSelectLayout);

    // Wallpaper preview
    wallpaperPreview = new WallpaperPreview;
    wallpaperLayout->addWidget(wallpaperPreview, 0, Qt::AlignCenter);

    connect(browseBtn, &QPushButton::clicked, this,
            &DotfilesInstaller::selectWallpaper);

    layout->addWidget(wallpaperGroup);

    // Color scheme section
    auto *colorGroup = new QGroupBox("Color Configuration");
    colorGroup->setStyleSheet(
        "QGroupBox { font-weight: bold; margin-top: 10px; }");
    auto *colorLayout = new QVBoxLayout(colorGroup);

    generateColorScheme = new QCheckBox("Generate colors from wallpaper");
    generateColorScheme->setEnabled(false);
    generateColorScheme->setStyleSheet(
        "QCheckBox { font-size: 14px; padding: 5px; }");
    colorLayout->addWidget(generateColorScheme);

    // Theme selection (for wallpaper generation)
    auto *themeSelectLayout = new QHBoxLayout;
    themeLabel = new QLabel("Generation theme:");
    themeCombo = new QComboBox;
    themeCombo->addItems({"dark", "light", "warm"});
    themeCombo->setStyleSheet("QComboBox { padding: 5px; }");
    themeSelectLayout->addWidget(themeLabel);
    themeSelectLayout->addWidget(themeCombo);
    themeSelectLayout->addStretch();
    colorLayout->addLayout(themeSelectLayout);

    // Predefined scheme selection
    auto *schemeSelectLayout = new QHBoxLayout;
    schemeLabel = new QLabel("Predefined scheme:");
    schemeCombo = new QComboBox;
    schemeCombo->addItems({"catppuccin-mocha", "catppuccin-latte", 
                          "gruvbox-dark", "gruvbox-light", "dracula"});
    schemeCombo->setStyleSheet("QComboBox { padding: 5px; }");
    schemeSelectLayout->addWidget(schemeLabel);
    schemeSelectLayout->addWidget(schemeCombo);
    schemeSelectLayout->addStretch();
    colorLayout->addLayout(schemeSelectLayout);

    connect(generateColorScheme, &QCheckBox::toggled, this,
            &DotfilesInstaller::onColorModeChanged);

    layout->addWidget(colorGroup);

    // Initialize visibility
    onColorModeChanged();

    layout->addStretch();

    // Install button
    installBtn = new QPushButton("Install Dotfiles");
    installBtn->setStyleSheet(R"(
            QPushButton {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 15px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #45a049;
            }
            QPushButton:pressed {
                background-color: #3d8b40;
            }
            QPushButton:disabled {
                background-color: #666;
                color: #aaa;
            }
        )");
    layout->addWidget(installBtn);

    connect(installBtn, &QPushButton::clicked, this,
            &DotfilesInstaller::startInstallation);
  }

  void setupRightPanel(QWidget *parent) {
    auto *layout = new QVBoxLayout(parent);

    // Progress section
    auto *progressGroup = new QGroupBox("Installation Progress");
    progressGroup->setStyleSheet(
        "QGroupBox { font-weight: bold; margin-top: 10px; }");
    auto *progressLayout = new QVBoxLayout(progressGroup);

    statusLabel = new QLabel("Ready to install");
    statusLabel->setStyleSheet("font-size: 14px; padding: 5px;");
    progressLayout->addWidget(statusLabel);

    progressBar = new QProgressBar;
    progressBar->setStyleSheet(R"(
            QProgressBar {
                border: 2px solid #555;
                border-radius: 5px;
                text-align: center;
                font-weight: bold;
            }
            QProgressBar::chunk {
                background-color: #4CAF50;
                border-radius: 3px;
            }
        )");
    progressLayout->addWidget(progressBar);

    layout->addWidget(progressGroup);

    // Log output
    auto *logGroup = new QGroupBox("Installation Log");
    logGroup->setStyleSheet(
        "QGroupBox { font-weight: bold; margin-top: 10px; }");
    auto *logLayout = new QVBoxLayout(logGroup);

    logOutput = new QTextEdit;
    logOutput->setReadOnly(true);
    logOutput->setStyleSheet(R"(
            QTextEdit {
                background-color: #1e1e1e;
                color: #ffffff;
                border: 1px solid #555;
                border-radius: 5px;
                font-family: 'Consolas', 'Monaco', monospace;
                font-size: 12px;
            }
        )");
    logLayout->addWidget(logOutput);

    layout->addWidget(logGroup);
  }

  void setupConnections() {
    // Worker connections will be set up in setupWorkerThread
  }

  void setupWorkerThread() {
    workerThread = new QThread(this);
    worker = new InstallWorker;
    worker->moveToThread(workerThread);

    connect(worker, &InstallWorker::statusUpdate, this,
            &DotfilesInstaller::onStatusUpdate);
    connect(worker, &InstallWorker::progressUpdate, this,
            &DotfilesInstaller::onProgressUpdate);
    connect(worker, &InstallWorker::installationComplete, this,
            &DotfilesInstaller::onInstallationComplete);
    connect(worker, &InstallWorker::installationError, this,
            &DotfilesInstaller::onInstallationError);

    connect(workerThread, &QThread::finished, worker, &QObject::deleteLater);
    workerThread->start();
  }

  void setUIEnabled(bool enabled) {
    for (auto *checkbox : packageCheckboxes) {
      checkbox->setEnabled(enabled);
    }
    installBtn->setEnabled(enabled);
    wallpaperPath->setEnabled(enabled);
    generateColorScheme->setEnabled(enabled &&
                                    !wallpaperPath->text().isEmpty());
    themeCombo->setEnabled(enabled);
    schemeCombo->setEnabled(enabled);
  }

  void applyDarkTheme() {
    setStyleSheet(R"(
            QMainWindow {
                background-color: rgba(0, 0, 0, 0);
                color: #ffffff;
            }
            QWidget {
                background-color: #2b2b2b;
                color: #ffffff;
            }
            QGroupBox {
                border: 2px solid #555;
                border-radius: 5px;
                margin-top: 10px;
                padding-top: 10px;
            }
            QGroupBox::title {
                subcontrol-origin: margin;
                left: 10px;
                padding: 0 5px 0 5px;
            }
            QLineEdit {
                border: 2px solid #555;
                border-radius: 5px;
                padding: 8px;
                background-color: #3a3a3a;
            }
            QLineEdit:focus {
                border-color: #4CAF50;
            }
            QPushButton {
                border: 2px solid #555;
                border-radius: 5px;
                padding: 8px 16px;
                background-color: #3a3a3a;
            }
            QPushButton:hover {
                background-color: #4a4a4a;
                border-color: #777;
            }
            QPushButton:pressed {
                background-color: #2a2a2a;
            }
            QComboBox {
                border: 2px solid #555;
                border-radius: 5px;
                padding: 5px;
                background-color: #3a3a3a;
            }
            QComboBox:hover {
                border-color: #777;
            }
            QComboBox::drop-down {
                border: none;
            }
            QComboBox::down-arrow {
                image: url(down_arrow.png);
            }
            QScrollArea {
                border: 1px solid #555;
                border-radius: 5px;
            }
        )");
  }

private:
  // UI Components
  std::vector<PackageCheckBox *> packageCheckboxes;
  QLineEdit *wallpaperPath;
  WallpaperPreview *wallpaperPreview;
  QCheckBox *generateColorScheme;
  QComboBox *themeCombo;
  QLabel *themeLabel;
  QComboBox *schemeCombo;
  QLabel *schemeLabel;
  QPushButton *installBtn;
  QProgressBar *progressBar;
  QLabel *statusLabel;
  QTextEdit *logOutput;

  // Worker thread
  QThread *workerThread;
  InstallWorker *worker;
};

#include "main-gui.moc"

int main(int argc, char *argv[]) {
  QApplication app(argc, argv);

  // Set application properties
  app.setApplicationName("Hyprland Dotfiles Installer");
  app.setApplicationVersion("1.0");
  app.setOrganizationName("YourName");

  DotfilesInstaller installer;
  installer.show();

  return app.exec();
}
