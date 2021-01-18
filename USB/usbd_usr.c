/**
  ******************************************************************************
  * @file    usbd_usr.c
  * @author  MCD Application Team
  * @version V1.1.0
  * @date    19-March-2012
  * @brief   This file includes the user application layer
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT 2012 STMicroelectronics</center></h2>
  *
  * Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
  * You may not use this file except in compliance with the License.
  * You may obtain a copy of the License at:
  *
  *        http://www.st.com/software_license_agreement_liberty_v2
  *
  * Unless required by applicable law or agreed to in writing, software 
  * distributed under the License is distributed on an "AS IS" BASIS, 
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
  ******************************************************************************
  */ 

/* Includes ------------------------------------------------------------------*/
#include "usbd_usr.h"
#include "usbd_ioreq.h"
#include "usb_conf.h"

#include  "usbd_desc.h"
#include  "usbd_hid_core.h"

/** @addtogroup STM32_USB_OTG_DEVICE_LIBRARY
* @{
*/

/** @defgroup USBD_USR 
* @brief    This file includes the user application layer
* @{
*/ 

/** @defgroup USBD_USR_Private_TypesDefinitions
* @{
*/ 
/**
* @}
*/ 


/** @defgroup USBD_USR_Private_Defines
* @{
*/ 
/**
* @}
*/ 


/** @defgroup USBD_USR_Private_Macros
* @{
*/ 
/**
* @}
*/ 


/** @defgroup USBD_USR_Private_Variables
* @{
*/ 

USBD_Usr_cb_TypeDef USR_cb =
{
  USBD_USR_Init,
  USBD_USR_DeviceReset,
  USBD_USR_DeviceConfigured,
  USBD_USR_DeviceSuspended,
  USBD_USR_DeviceResumed,
  
  USBD_USR_DeviceConnected,
  USBD_USR_DeviceDisconnected,  
  
  
};



/**
* @}
*/

/** @defgroup USBD_USR_Private_Constants
* @{
*/ 

/**
* @}
*/



/** @defgroup USBD_USR_Private_FunctionPrototypes
* @{
*/ 
/**
* @}
*/ 


/** @defgroup USBD_USR_Private_Functions
* @{
*/ 

#define USER_INFORMATION1      "[Key]:RemoteWakeup"
#define USER_INFORMATION2      "[Joystick]:Mouse emulation"


/**
* @brief  USBD_USR_Init 
*         Displays the message on LCD for host lib initialization
* @param  None
* @retval None
*/
void USBD_USR_Init(void)
{  
}

/**
* @brief  USBD_USR_DeviceReset 
*         Displays the message on LCD on device Reset Event
* @param  speed : device speed
* @retval None
*/
void USBD_USR_DeviceReset(uint8_t speed )
{
 switch (speed)
 {
   case USB_OTG_SPEED_HIGH: 
     break;

  case USB_OTG_SPEED_FULL: 
     break;
     
 }
}


/**
* @brief  USBD_USR_DeviceConfigured
*         Displays the message on LCD on device configuration Event
* @param  None
* @retval Staus
*/
void USBD_USR_DeviceConfigured (void)
{
}


/**
* @brief  USBD_USR_DeviceConnected
*         Displays the message on LCD on device connection Event
* @param  None
* @retval Staus
*/
void USBD_USR_DeviceConnected (void)
{
}


/**
* @brief  USBD_USR_DeviceDisonnected
*         Displays the message on LCD on device disconnection Event
* @param  None
* @retval Staus
*/
void USBD_USR_DeviceDisconnected (void)
{
}

/**
* @brief  USBD_USR_DeviceSuspended 
*         Displays the message on LCD on device suspend Event
* @param  None
* @retval None
*/
void USBD_USR_DeviceSuspended(void)
{
  /* Users can do their application actions here for the USB-Reset */
}


/**
* @brief  USBD_USR_DeviceResumed 
*         Displays the message on LCD on device resume Event
* @param  None
* @retval None
*/
void USBD_USR_DeviceResumed(void)
{
  /* Users can do their application actions here for the USB-Reset */
}

/**
* @}
*/ 

/**
* @}
*/ 


#include <stdio.h>

/*static*//*stm32f4xx_it.c:196: undefined reference to `USB_OTG_dev'*/ USB_OTG_CORE_HANDLE  USB_OTG_dev;

#if 0

extern void Button_Click (void);


#define MOUSE_DELTA  5
#define Buttons buf[0]
#define X  buf[1]
#define Y  buf[2]
void USB_Mouse(void)
{
  unsigned char buf[4] = {0, 0, 0, 0};
  unsigned int Direction=0, i=0;
  unsigned int Timeout = 0;

  printf ("Connect USB to move the mouse cursor and press the button!\r\n");
  Button_Click ();
  printf ("Press the button to stop!\r\n");

  while (!STM_EVAL_PBGetState (BUTTON_WAKEUP))
  {
      if (!Timeout)
      {
         STM_EVAL_LEDToggle (LED1);
         Timeout = 30;
      }
      else
         Timeout--;
      switch (Direction)
      {
      case 0:
           X += MOUSE_DELTA;
           i++;
           Direction = (Direction + (i>>5)) & 3;
           i = i & 0x1F;
        break;
      case 1:
          Y += MOUSE_DELTA;
           i++;
           Direction = (Direction + (i>>5)) & 3;
           i = i & 0x1F;
        break;
      case 2:
          X -= MOUSE_DELTA;
           i++;
           Direction = (Direction + (i>>5)) & 3;
           i = i & 0x1F;
        break;
      case 3:
          Y -= MOUSE_DELTA;
           i++;
           Direction = (Direction + (i>>5)) & 3;
           i = i & 0x1F;
        break;
      default:
        break;
      }

      if(Y || X)
      {
        // Send report
        USBD_HID_SendReport (&USB_OTG_dev, buf, 4);
        Y = X = 0;
      }
  }
  while (STM_EVAL_PBGetState (BUTTON_WAKEUP));
  return;
}

#endif


void USB_Task(void* p)
{
  printf("Start USB task.\n");

  USBD_Init(&USB_OTG_dev, USB_OTG_FS_CORE_ID, &USR_desc, &USBD_HID_cb, &USR_cb);
//  USB_Mouse ();

  for (;;)
  {
    // TODO some other test

    vTaskDelay(1000);
  }

  vTaskDelete(NULL);
}



/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
