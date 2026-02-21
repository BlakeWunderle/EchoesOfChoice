using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Pierce : Ability
    {
        public Pierce()
        {
            Name = "Pierce";
            FlavorText = "Shoot an Enemy directly in the heart.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 3;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
