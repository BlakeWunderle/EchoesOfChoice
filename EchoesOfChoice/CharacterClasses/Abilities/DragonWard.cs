using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class DragonWard : Ability
    {
        public DragonWard()
        {
            Name = "Dragon Ward";
            FlavorText = "Summon a draconic aura that shields against attacks. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
