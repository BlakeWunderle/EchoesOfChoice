using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class HeavenlyBody : Ability
    {
        public HeavenlyBody()
        {
            Name = "Heavenly Body";
            FlavorText = "Wrap allies in celestial light, shielding them from harm. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
