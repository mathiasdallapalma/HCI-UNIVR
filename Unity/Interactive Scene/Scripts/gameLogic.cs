using System;
using Mono.Cecil;
using UnityEngine;
using UnityEngine.UI;

public class gameLogic : MonoBehaviour
{
    Camera mainCamera;
    Image image;

    MyImage[] images = new MyImage[]
    {
        new MyImage("IMG_656_75", new Vector3(-33.38412f, 2.5f, -8.301064f), new Vector3(-0.16f, 72.576f, -3.743f)),
        new MyImage("IMG_704_75", new Vector3(-28.09573f, 2.581532f, -13.56871f), new Vector3(4.423f, 58.828f, -3.161f)),
        new MyImage("IMG_720_75", new Vector3(-15.93244f, 2.783541f, -23.78055f), new Vector3(-0.714f, 38.845f, -0.723f)),
        new MyImage("IMG_801_75", new Vector3(8.220961f, 3.49666f, -42.1196f), new Vector3(0.844f, 4.479f, 3.196f)),
        new MyImage("OLD_IMG",new Vector3(-34.16f, 2.93f, 1.8337f), new Vector3(6.588f, 96.56f, -1.251f))
    };
    int index = 0;

    int score = 0;

    class MyImage
    {
        public string name;
        public Vector3 position;

        public Vector3 rotation;
        public MyImage(string name, Vector3 position, Vector3 rotation)
        {
            this.name = name;
            this.position = position;
            this.rotation = rotation;
        }
    }




    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        mainCamera = Camera.main;
        image = mainCamera.GetComponentInChildren<Image>();


    }

    // Update is called once per frame
    void Update()
    {
        //toggle if space is pressed
        if (Input.GetKeyDown(KeyCode.Space))
        {
            image.enabled = !image.enabled;
            //show ui text if image is enabled
            if (image.enabled)
            {

                // Load the texture from Resources
                Texture2D texture = Resources.Load<Texture2D>("Images/" + images[index].name);
                // Convert Texture2D to Sprite
                Sprite sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f));

                // Assign the sprite to the UI Image component
                image.sprite = sprite;



                //Resources.Load<Sprite>("buildings/factory/");
                mainCamera.GetComponentInChildren<TMPro.TextMeshProUGUI>().text = "Find the place where the image is taken from then press SPACE to give your answer";
            }
            else
            {
                Vector3 distancePosition = mainCamera.transform.position - images[index].position;
                

                double new_score = distancePosition.magnitude;
               
                new_score=100*Math.Exp(-0.05*new_score);
                


                score += (int)new_score;

                mainCamera.GetComponentsInChildren<TMPro.TextMeshProUGUI>()[1].text = "Score: " + score;


                index = (index + 1) % images.Length;
                mainCamera.GetComponentInChildren<TMPro.TextMeshProUGUI>().text = "Press SPACE to start the game";
            }
        }





    }
}
