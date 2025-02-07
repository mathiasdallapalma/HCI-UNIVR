using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEngine.UI;
using Unity.Collections;
using System;
using Unity.VisualScripting;
using System.Xml;
using System.Xml.Linq;
using Unity.Mathematics;


[ExecuteInEditMode]
public class SetUpSceneScript : MonoBehaviour
{

    public bool run;
    public GameObject model;
    public Sprite image;
    public TextAsset json;
    public TextAsset xmp;
    public float sensorSizeX;

    private GameObject cameraObject;

    private void PlaceModel(){
        GameObject modelObject = Instantiate(model);
        modelObject.name = "Model";
        modelObject.transform.rotation = Quaternion.Euler(-90, 180, 0);
        modelObject.AddComponent<MeshCollider>();
        modelObject.GetComponent<MeshCollider>().sharedMesh= modelObject.GetComponentInChildren<MeshFilter>().sharedMesh;
    }
    private void PlaceandSetupCamera(CameraParameter cameraParameter){
            cameraObject = new GameObject("CAMERA2");
            cameraObject.AddComponent<Camera>();
            Camera camera = cameraObject.GetComponent<Camera>();
            
            
            camera.name = "CAMERA2";
            camera.transform.position = cameraParameter.Position;
            camera.transform.rotation = cameraParameter.Rotation;
            
            camera.usePhysicalProperties = true;
            camera.focalLength = cameraParameter.FocalLenght;
            camera.sensorSize = cameraParameter.SensorSize;
            camera.lensShift = cameraParameter.LensShift;
    }
    private CameraParameter GetCameraParameterFromXmp(){
    /*
    Recover the parameters from the xmp file produced by Zephyr to define a custom camera in Unity
    */

        CameraParameter res= new CameraParameter();

        // Load the XML content
        XElement xml = XElement.Parse(xmp.text);
        
        // Extract calibration attributes
        XElement calibration = xml.Element("calibration");
        XElement extrinsics = xml.Element("extrinsics");



        //res.FocalLenght = float.Parse(calibration?.Attribute("lense")?.Value);
        
        float Iw = float.Parse(calibration?.Attribute("w")?.Value);
        float Ih = float.Parse(calibration?.Attribute("h")?.Value);
        
        float cx= float.Parse(calibration?.Attribute("cx")?.Value, System.Globalization.CultureInfo.InvariantCulture);
        float cy = float.Parse(calibration?.Attribute("cy")?.Value, System.Globalization.CultureInfo.InvariantCulture);

        float fx = float.Parse(calibration?.Attribute("fx")?.Value, System.Globalization.CultureInfo.InvariantCulture);
        float fy = float.Parse(calibration?.Attribute("fy")?.Value, System.Globalization.CultureInfo.InvariantCulture);

        string rotation = extrinsics?.Element("rotation")?.Value;
        rotation = rotation.Replace(".", ",");
        float[] rotation_array = Array.ConvertAll(rotation.Split(' '), float.Parse);
        float3x3 R = new float3x3(rotation_array[0], rotation_array[1], rotation_array[2],
                                rotation_array[3], rotation_array[4], rotation_array[5],
                                rotation_array[6], rotation_array[7], rotation_array[8]);


        string translation = extrinsics?.Element("translation")?.Value;
        translation = translation.Replace(".", ",");
        float[] translation_array = Array.ConvertAll(translation.Split(' '), float.Parse);
        float3 t = new float3(translation_array[0], translation_array[1], translation_array[2]);

        res.SensorSize.x=sensorSizeX;

        float fmm=fx*(res.SensorSize.x/Iw);
        res.FocalLenght=fmm;

        res.SensorSize.y=fmm*(Ih/fy);
    

        res.LensShift.x=-(cx-(Iw/2))/Iw;
        res.LensShift.y=(cy-(Ih/2))/Ih;

        Debug.Log("Lens Shift: "+res.LensShift);

        //Mirror y-axis:
        float3x3 Sy=new float3x3(1, 0, 0,
                                0,-1, 0,
                                0, 0, 1);

        //Invert Y-axis with Z-axis
        float3x3 YZ=new float3x3(1, 0, 0,
                                0, 0, 1,
                                0, 1, 0); 

        //Compute the Rotation and Translation in the Unity ref (from camera to world)
        float3x3 Sy_r_transposed=math.transpose(math.mul(Sy,R));
        float3   Sy_t=math.mul(Sy,t);

        float3x3 R_u=math.mul(YZ,Sy_r_transposed);
        float3   T_u=math.mul(YZ,math.mul(-(Sy_r_transposed),Sy_t));
        res.Position.x=T_u.x;
        res.Position.y=T_u.y;
        res.Position.z=T_u.z;

        //Compute the Euler angles from the Rotation Matrix
        float3 R_eulerian=GetEulerAnglesFromRotationMatrix(R_u);
        res.Rotation=Quaternion.Euler(R_eulerian.x,R_eulerian.y,R_eulerian.z);
        return res;
    }
    private void PlaceImage(){
                    //create a new canvas 
            GameObject canvasObject = new GameObject("Canvas");
            canvasObject.AddComponent<Canvas>();
            canvasObject.AddComponent<CanvasScaler>();
            
            canvasObject.GetComponent<CanvasScaler>().uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;

            Canvas canvas = canvasObject.GetComponent<Canvas>();

            canvas.name="Canvas2";
            canvas.transform.SetParent(cameraObject.transform,false);
            
            canvas.worldCamera = GetComponent<Camera>();
            canvas.renderMode = RenderMode.ScreenSpaceCamera;


            //create a new image
            GameObject imageObject = new GameObject("Image");
            imageObject.AddComponent<Image>();
            Image rawImage = imageObject.GetComponent<Image>();
            

            rawImage.name = "Image2";
            rawImage.transform.SetParent(canvasObject.transform,false);
            rawImage.sprite = image;
            rawImage.preserveAspect = true;
            
            RectTransform rectTransform = rawImage.GetComponent<RectTransform>();
            rectTransform.anchorMin = new Vector2(0,0);
            rectTransform.anchorMax = new Vector2(1,1);
            rectTransform.offsetMin = new Vector2(rectTransform.offsetMin.x, 0);
            rectTransform.offsetMax = new Vector2(rectTransform.offsetMax.x, 0);
            rectTransform.sizeDelta = new Vector2(0,0);
    }


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }
    public static Vector3 GetEulerAnglesFromRotationMatrix(float3x3 m)
    {
        // Calculate Euler angles from rotation matrix

        // Adjust the rotation matrix to the Unity ref
        float m00 = m[2][2];
        float m01 = m[0][2];
        float m02 = m[1][2];
        float m10 = m[2][0];
        float m11 = m[0][0];
        float m12 = m[1][0];
        float m20 = m[2][1];
        float m21 = m[0][1];
        float m22 = m[1][1];

        float3x3 R_eun1 = new float3x3(m00, m01, m02,
                                 m10, m11, m12,
                                 m20, m21, m22);
        
        
  
        float sy = Mathf.Sqrt(m21* m21 + m22 * m22);

        bool singular = sy < 1e-6; // If sy is near-zero, use a different convention

        float x, y, z;
        if (!singular)
        {
            z = Mathf.Atan2(m21, m22);
            x = Mathf.Atan2(-m20, sy);
            y = Mathf.Atan2(m10, m00);
        }
        else
        {
            z = Mathf.Atan2(-m12, m11);
            x = Mathf.Atan2(-m20, sy);
            y = 0;
        }

        x = Mathf.Rad2Deg * x;
        y = Mathf.Rad2Deg * y;
        z = Mathf.Rad2Deg * z;

        return new Vector3(x, y, z); 
    }

    // Update is called once per frame
    void Update()
    {
       
    if (run){
            //create a new model from the mesh
            PlaceModel();

            CameraParameter data = GetCameraParameterFromXmp();
                      
            //create a new camera
            PlaceandSetupCamera(data);

            PlaceImage();
      
            run=false;
        }
        
    }

    
}


public class CameraParameter
{
    public float FocalLenght;
    public Vector2 SensorSize;
    public Vector2 LensShift;
    public Vector3 Position;
    public Quaternion Rotation;

}






