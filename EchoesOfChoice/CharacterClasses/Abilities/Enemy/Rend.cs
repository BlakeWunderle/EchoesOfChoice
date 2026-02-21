using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Rend : Ability
    {
        public Rend()
        {
            Name = "Rend";
            FlavorText = "Rotting claws tear through armor and flesh.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
