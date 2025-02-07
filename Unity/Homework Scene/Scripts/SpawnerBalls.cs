using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnerBalls : MonoBehaviour
{
    [SerializeField]
    private GameObject modelRocket;


    [SerializeField]
    public GameObject modelBall;
    [SerializeField]
    public float force;

    public GameObject camera1;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GameObject clone = Instantiate<GameObject>(modelRocket);
            clone.SetActive(true);
        }
        if (Input.GetKeyDown(KeyCode.W))
        {
            GameObject activeCamera=camera1;
            GameObject clone = Instantiate<GameObject>(modelBall);
            clone.SetActive(true);
            clone.transform.position = activeCamera.transform.position;
            clone.transform.rotation = activeCamera.transform.rotation;
            Vector3 deviation = new Vector3(Random.Range(-0.30f, 0.5f), Random.Range(-0.1f, 0.8f),1);
            //clone.GetComponent<Rigidbody>().AddForce(clone.transform.TransformDirection(Vector3.forward)* force, ForceMode.Impulse);
            clone.GetComponent<Rigidbody>().AddForce(clone.transform.TransformDirection(deviation) * force, ForceMode.Impulse);
        }

    }
}
