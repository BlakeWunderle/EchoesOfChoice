using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;

namespace EchoesOfChoice.Battles
{
    public class LabBattle : Battle
    {
        public LabBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Android() { CharacterName = "Deus" });
            Enemies.Add(new Machinist() { CharacterName = "Ananiah" });
            Enemies.Add(new Ironclad() { CharacterName = "Acrid" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
                NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The machines power down one by one, sparks fading to nothing. The building hums its last and goes dark.");
            Console.WriteLine("In the silence a reflection catches the party's eye. A mirror sits on the lab table, its surface impossibly clear.");
            Console.WriteLine("It doesn't reflect the room. It reflects something else entirely.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Travelling to the North West, everyone begins to notice static in the air.");
            Console.WriteLine("A large building looms in the distance and the group enters it trying to figure out the cause.");
            Console.WriteLine("Outlined under a cloth a human shape lies on a table.");
            Console.WriteLine("The cloth drops to the ground and a laser blasts past the party.");
        }
    }
}
