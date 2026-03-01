using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class StrangerFinalBattle : Battle
    {
        public StrangerFinalBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new StrangerFinal() { CharacterName = "The Stranger" });
            IsFinalBattle = true;
        }

        public override void DetermineNextBattle()
        {
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The stranger's form shatters. The darkness fractures and light pours in from above.");
            Console.WriteLine("The sigils die one by one. The cavern begins to collapse. The party runs.");
            Console.WriteLine("Outside, the sky is clearing. The ash-colored clouds break apart and sunlight hits the land for the first time in days.");
            Console.WriteLine("The city stirs. People emerge from hiding. It's over.");
            Console.WriteLine("The stranger is gone and with them, the shadow. The world will heal. It will take time, but it will heal.");
            Console.WriteLine("The party stands in the light, bruised and exhausted and alive. Whatever comes next, they'll face it together.");
            Console.WriteLine();
            Console.WriteLine("THE END.");
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The sanctum is a cavern of pure darkness. Sigils cover every surface, pulsing in rhythm like a heartbeat.");
            Console.WriteLine("The stranger stands at the center, wreathed in shadow. Their true form is barely human now — taller, darker, their eyes burning with void light.");
            Console.WriteLine("\"You made it. I'm impressed. But you're too late. The ritual is complete. This world belongs to the shadow now.\"");
            Console.WriteLine("They raise their hands and the darkness surges.");
            Console.WriteLine("\"Let's finish this.\"");
        }
    }
}
