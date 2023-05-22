// Master

Include("scriptlib/nad.nut");

print("--Master() : Master Script");

g_level			<-	0;
g_scene			<-	0;
g_renderer		<-	0;

g_renderer = EngineGetRenderer(g_engine);
RendererSetViewport(g_renderer, 0.0, 0.0, 800.0, 600.0);

g_scene = ProjectNewScene(g_project);

g_level = SceneFromNMLStoreGroup(g_scene, "levels/paper_tower_0/room_0.nms", FlagLoadAll); 
SceneSetup(g_scene);
SceneReset(g_scene);
EngineSetupResources(g_engine);
SceneSetCurrentCamera(g_scene, ItemCastToCamera(SceneFindItem(g_scene, "ingame_camera")));

KeyboardUpdate();

while(!KeyboardSeekFunction(DeviceKeyPress, KeyEscape))
{
	EngineBeginDraw(g_engine);

	RendererClearFrame(g_renderer, 0.0, 0.0, 0.0);

	SceneUpdate(g_scene);
	SceneRenderToQueue(g_scene);
	RendererRenderQueue(g_renderer);

	EngineEndDraw(g_engine);
}

SceneEnd(g_scene);
