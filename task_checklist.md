# LoveMe 开发任务清单

## 📋 开发流程

### ✅ 阶段 1: 项目初始化
- [ ] 创建 Flutter 项目
- [ ] 配置 pubspec.yaml
- [ ] 建立项目目录结构
- [ ] 添加静态资源文件夹

### ✅ 阶段 2: 数据模型
- [ ] Character 模型
- [ ] DialogueRecord 模型
- [ ] GameSave 模型
- [ ] MemoryEntry 模型
- [ ] AIConfig 模型
- [ ] MiniGameRecord 模型
- [ ] FocusRecord 模型
- [ ] DynamicEventRecord 模型
- [ ] EmotionState 模型
- [ ] 运行 build_runner 生成 Hive 适配器

### ✅ 阶段 3: 核心服务
- [ ] StorageService 实现
  - [ ] Hive 初始化
  - [ ] SharedPreferences 集成
  - [ ] flutter_secure_storage 密钥管理
  - [ ] 文件操作（CG保存）
- [ ] AIService 实现
  - [ ] 流式响应处理
  - [ ] API 配置管理
  - [ ] 图片生成集成
- [ ] SpeechService 实现

### ✅ 阶段 4: 管理器
- [ ] CharacterManager
- [ ] MemoryManager
  - [ ] 短期记忆管理
  - [ ] 中期记忆压缩
  - [ ] 长期记忆提炼
- [ ] AffectionManager
  - [ ] 好感度计算
  - [ ] 每日上限检查
  - [ ] 里程碑检测
- [ ] EmotionManager
- [ ] DialogueManager
- [ ] SceneManager
- [ ] MiniGameManager
  - [ ] 21点游戏逻辑
  - [ ] 成语接龙逻辑
- [ ] FocusTimerManager（伴学系统）

### ✅ 阶段 5: 工具类
- [ ] PromptBuilder
  - [ ] 对话提示词构建
  - [ ] 场景提示词构建
  - [ ] 结局提示词构建
- [ ] MemoryCompressor

### ✅ 阶段 6: UI 实现
- [ ] WelcomeScreen
- [ ] CharacterSelectScreen
- [ ] MainGameScreen
  - [ ] 对话气泡组件
  - [ ] 流式对话组件
  - [ ] 好感度进度条
  - [ ] 输入工具栏
- [ ] SceneScreen
  - [ ] CG 展示
  - [ ] 对话文本逐字显示
  - [ ] 选项按钮
- [ ] SettingsScreen
  - [ ] API Key 配置
  - [ ] 打字速度设置
  - [ ] 主题设置
  - [ ] 清除数据
- [ ] TutorialScreen
- [ ] MiniGameMenuScreen
- [ ] BlackjackGameScreen
- [ ] IdiomGameScreen
- [ ] FocusTimerScreen

### ✅ 阶段 7: 资源文件
- [ ] assets/characters.json
- [ ] assets/dialogue_templates.json
- [ ] assets/idioms.json
- [ ] 角色头像资源
- [ ] 角色立绘资源
- [ ] 教程图片

### ✅ 阶段 8: 集成与测试
- [ ] 所有模块集成
- [ ] 存档/加载测试
- [ ] AI 响应测试
- [ ] 小游戏测试
- [ ] 伴学系统测试
- [ ] 性能优化

---

## 📝 注意事项

1. 严格按照 [spec.md](file:///workspace/spec.md) 中的要求实现
2. 每个模块完成后进行充分测试
3. 保持代码风格一致
4. 适当添加注释
5. 先实现核心功能，再完善细节
