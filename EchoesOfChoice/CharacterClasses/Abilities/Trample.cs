using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Trample : Ability
    {
        public Trample()
        {
            Name = "Trample";
            FlavorText = "Charge through the enemy on horseback, crushing everything underfoot.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
