using UnityEngine;

public class cameraMovement : MonoBehaviour
{

    public float movementSpeed = 5;
    public float gravity = -5;

    float hoverHeight = 2.5f;
    float sensitivity = 20.0f;
    float rotZIncrement = 1.0f;



    void Start()
    {
    }

    void Update()
    {
        // Move the camera with WASD
        transform.position += transform.forward * Time.deltaTime * movementSpeed * Input.GetAxis("Vertical");
        transform.position += transform.right * Time.deltaTime * movementSpeed * Input.GetAxis("Horizontal");


        // Apply gravity 
        RaycastHit hit;
        Ray downRay = new Ray(transform.position, -Vector3.up);
    
        // Cast a ray straight downwards.
        if (Physics.Raycast(downRay, out hit))
        {
            float hoverError = hoverHeight - hit.distance;

            // Only apply a lifting force if the object is too low (ie, let
            // gravity pull it downward if it is too high).
            if (hoverError != 0)
            {
                // Subtract the damping from the lifting force and apply it to
                // the rigidbody.
                transform.position = new Vector3(transform.position.x, transform.position.y+hoverError, transform.position.z);
            }
        }

        //move looking direction with mouse
        float mouseX = Input.GetAxis("Mouse X") * sensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * sensitivity * Time.deltaTime;
        float rotZ=0;
        if(Input.GetKey(KeyCode.Q)){
            rotZ = rotZIncrement*Time.deltaTime;
        }
        if(Input.GetKey(KeyCode.E)){
            rotZ = -rotZIncrement*Time.deltaTime;
        }

        Vector3 rotVec = new Vector3(mouseY, mouseX, rotZ);
        transform.localEulerAngles +=rotVec;


    }
}